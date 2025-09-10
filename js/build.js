const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

// Configuration
const TEI_FILE = './data/Tagebuch.xml';
const XSLT_FILE = './xslt/diary-to-html.xsl';
const OUTPUT_DIR = './docs';
const OUTPUT_FILE = path.join(OUTPUT_DIR, 'index.html');

// Ensure output directory exists
if (!fs.existsSync(OUTPUT_DIR)) {
    fs.mkdirSync(OUTPUT_DIR, { recursive: true });
}

try {
    // Method 1: Using Saxon-HE (if installed)
    // Download from: https://sourceforge.net/projects/saxon/files/Saxon-HE/
    console.log('Transforming TEI to HTML...');
    
    const command = `java -jar saxon-he.jar -s:"${TEI_FILE}" -xsl:"${XSLT_FILE}" -o:"${OUTPUT_FILE}"`;
    
    try {
        execSync(command, { stdio: 'inherit' });
        console.log(`✅ Transformation complete! Output: ${OUTPUT_FILE}`);
    } catch (error) {
        console.log('❌ Saxon not found. Using alternative method...');
        
        // Method 2: Simple file copy with placeholder replacement
        // This is a fallback - you'd need to implement actual XSLT processing
        const teiContent = fs.readFileSync(TEI_FILE, 'utf8');
        
        // Very basic HTML generation (you'd want to use a proper XSLT processor)
        const basicHtml = `
<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Berliner Tagebuch - Arnold Schönberg</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <header>
        <h1>Berliner Tagebuch</h1>
        <p>Arnold Schönberg, 1912</p>
    </header>
    <main>
        <p>TEI transformation in progress. Please use a proper XSLT processor.</p>
        <details>
            <summary>Raw TEI Data</summary>
            <pre>${teiContent.replace(/</g, '&lt;').replace(/>/g, '&gt;')}</pre>
        </details>
    </main>
</body>
</html>`;
        
        fs.writeFileSync(OUTPUT_FILE, basicHtml);
        console.log('📝 Basic HTML fallback created');
    }
    
    // Copy CSS and JS files
    const cssDir = path.join(OUTPUT_DIR, 'css');
    const jsDir = path.join(OUTPUT_DIR, 'js');
    
    if (!fs.existsSync(cssDir)) fs.mkdirSync(cssDir, { recursive: true });
    if (!fs.existsSync(jsDir)) fs.mkdirSync(jsDir, { recursive: true });
    
    // Copy assets if they exist
    if (fs.existsSync('./css/style.css')) {
        fs.copyFileSync('./css/style.css', path.join(cssDir, 'style.css'));
    }
    
    if (fs.existsSync('./js/script.js')) {
        fs.copyFileSync('./js/script.js', path.join(jsDir, 'script.js'));
    }
    
    console.log('📁 Assets copied to docs directory');
    
} catch (error) {
    console.error('❌ Build failed:', error.message);
    process.exit(1);
}

// Create a simple package.json if it doesn't exist
const packageJsonPath = './package.json';
if (!fs.existsSync(packageJsonPath)) {
    const packageJson = {
        "name": "schoenberg-diary",
        "version": "1.0.0",
        "description": "Digital edition of Arnold Schönberg's Berlin Diary (1912)",
        "scripts": {
            "build": "node build.js",
            "serve": "python -m http.server 8000 --directory docs"
        },
        "author": "Your Name",
        "license": "CC-BY-NC-SA-4.0"
    };
    
    fs.writeFileSync(packageJsonPath, JSON.stringify(packageJson, null, 2));
    console.log('📦 package.json created');
}