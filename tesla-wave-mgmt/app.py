import os
import json
import shutil
from flask import Flask, render_template, jsonify, request, send_file
import soundfile as sf

app = Flask(__name__)

# Configuration
WAV_DIRECTORY = '/mnt/usb_share'
MAPPING_FILE = os.path.join(WAV_DIRECTORY, 'sound_mapping.json')

# Template configuration
TEMPLATE_CONFIG = {
    'default.html': {
        'name': 'Default',
        'description': 'Classic blue theme with clean layout',
        'themes': ['default', 'dark', 'light']
    },
    'modern.html': {
        'name': 'Modern',
        'description': 'Modern design with rounded corners',
        'themes': ['default', 'dark', 'light']
    },
    'minimal.html': {
        'name': 'Minimal',
        'description': 'Simple and minimalistic design',
        'themes': ['default', 'dark', 'light']
    }
}

def get_available_templates():
    """Get list of available templates and their themes."""
    templates = {}
    template_dir = os.path.join(app.root_path, 'templates')
    for filename in os.listdir(template_dir):
        if filename.endswith('.html') and filename in TEMPLATE_CONFIG:
            templates[filename] = TEMPLATE_CONFIG[filename]
    return templates

def sanitize_filename(filename):
    """Convert filename to lowercase, replace spaces with underscores, remove special chars."""
    # Keep extension separate
    name, ext = os.path.splitext(filename)
    # Convert to lowercase and replace spaces
    name = name.lower().replace(' ', '_')
    # Remove special characters except underscores and hyphens
    name = ''.join(c for c in name if c.isalnum() or c in ['_', '-'])
    return f"{name}{ext}"

def get_file_info(filepath):
    """Get duration and size of WAV file."""
    try:
        with sf.SoundFile(filepath) as audio_file:
            duration = len(audio_file) / audio_file.samplerate
        size_kb = os.path.getsize(filepath) / 1024
        return {
            'duration': round(duration, 1),
            'size': round(size_kb, 1)
        }
    except Exception:
        return {'duration': 0, 'size': 0}

def load_mapping():
    """Load name mapping from JSON file."""
    if os.path.exists(MAPPING_FILE):
        with open(MAPPING_FILE, 'r') as f:
            return json.load(f)
    return {'active_file': None}

def save_mapping(mapping):
    """Save name mapping to JSON file."""
    with open(MAPPING_FILE, 'w') as f:
        json.dump(mapping, f)

def check_lockchime_status():
    """Check status of lockchime.wav file."""
    lockchime_path = os.path.join(WAV_DIRECTORY, 'lockchime.wav')
    mapping = load_mapping()
    
    if not os.path.exists(lockchime_path):
        return {'status': 'missing'}
        
    lockchime_count = sum(1 for f in os.listdir(WAV_DIRECTORY) 
                         if f.lower() == 'lockchime.wav')
    if lockchime_count > 1:
        return {'status': 'duplicate'}
        
    if not mapping.get('active_file'):
        return {'status': 'unknown'}
        
    return {'status': 'ok', 'name': mapping['active_file']}

@app.route('/')
def index():
    """Main page route."""
    template = request.args.get('template', 'default.html')
    theme = request.args.get('theme', 'default')
    
    if template not in get_available_templates():
        template = 'default.html'
    
    return render_template(template, 
                         templates=get_available_templates(),
                         current_template=template,
                         current_theme=theme)

@app.route('/api/files')
def list_files():
    """API endpoint to list all WAV files with their info."""
    files = []
    mapping = load_mapping()
    
    for filename in os.listdir(WAV_DIRECTORY):
        if filename.lower().endswith('.wav'):
            filepath = os.path.join(WAV_DIRECTORY, filename)
            info = get_file_info(filepath)
            
            files.append({
                'filename': filename,
                'original_name': mapping.get('active_file') if filename == 'lockchime.wav' else filename,
                'duration': info['duration'],
                'size': info['size'],
                'is_active': filename == 'lockchime.wav'
            })
    
    return jsonify({
        'files': sorted(files, key=lambda x: (not x['is_active'], x['filename'])),
        'status': check_lockchime_status()
    })

@app.route('/api/activate', methods=['POST'])
def activate_file():
    """API endpoint to activate a WAV file as lockchime."""
    data = request.json
    filename = data.get('filename')
    new_name = data.get('new_name')  # For unknown lockchime case
    
    if not filename and not new_name:
        return jsonify({'error': 'No filename provided'}), 400
        
    mapping = load_mapping()
    lockchime_path = os.path.join(WAV_DIRECTORY, 'lockchime.wav')
    
    # Handle unknown lockchime case
    if new_name:
        if os.path.exists(lockchime_path):
            new_filename = f"{sanitize_filename(new_name)}.wav"
            mapping['active_file'] = new_filename
            save_mapping(mapping)
            return jsonify({'success': True})
    
    # Handle normal activation
    source_path = os.path.join(WAV_DIRECTORY, filename)
    if not os.path.exists(source_path):
        return jsonify({'error': 'File not found'}), 404
        
    # If there's an existing lockchime.wav, rename it back
    if os.path.exists(lockchime_path) and mapping.get('active_file'):
        original_name = mapping['active_file']
        if original_name != 'lockchime.wav':
            os.rename(lockchime_path, os.path.join(WAV_DIRECTORY, original_name))
    
    # Activate new file
    os.rename(source_path, lockchime_path)
    mapping['active_file'] = filename
    save_mapping(mapping)
    
    return jsonify({'success': True})

@app.route('/api/delete/<filename>', methods=['DELETE'])
def delete_file(filename):
    """API endpoint to delete a WAV file."""
    if filename == 'lockchime.wav':
        return jsonify({'error': 'Cannot delete active lockchime.wav'}), 400
        
    filepath = os.path.join(WAV_DIRECTORY, filename)
    if not os.path.exists(filepath):
        return jsonify({'error': 'File not found'}), 404
        
    os.remove(filepath)
    return jsonify({'success': True})

@app.route('/api/play/<filename>')
def play_file(filename):
    """API endpoint to serve WAV file for playback."""
    filepath = os.path.join(WAV_DIRECTORY, filename)
    if not os.path.exists(filepath):
        return jsonify({'error': 'File not found'}), 404
    response = send_file(filepath)
    response.headers['Cache-Control'] = 'no-store, no-cache, must-revalidate, max-age=0'
    response.headers['Pragma'] = 'no-cache'
    response.headers['Expires'] = '0'
    return response

if __name__ == '__main__':
    # Check if WAV directory exists
    if not os.path.exists(WAV_DIRECTORY):
        print(f"Error: WAV directory {WAV_DIRECTORY} not found")
        exit(1)
    app.run(host='0.0.0.0', port=80, debug=True)