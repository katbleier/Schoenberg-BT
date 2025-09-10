// Interactive features for TEI diary display
document.addEventListener('DOMContentLoaded', function() {
    
    // Smooth scrolling for navigation links
    const navLinks = document.querySelectorAll('nav a[href^="#"]');
    navLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            const targetId = this.getAttribute('href').substring(1);
            const targetElement = document.getElementById(targetId);
            if (targetElement) {
                targetElement.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });
    
    // Highlight person names on hover
    const personNames = document.querySelectorAll('.person');
    personNames.forEach(person => {
        const name = person.textContent.trim();
        
        person.addEventListener('mouseenter', function() {
            // Highlight all occurrences of the same person
            document.querySelectorAll('.person').forEach(p => {
                if (p.textContent.trim() === name) {
                    p.style.backgroundColor = '#b3d9ff';
                    p.style.fontWeight = 'bold';
                }
            });
        });
        
        person.addEventListener('mouseleave', function() {
            // Reset highlighting
            document.querySelectorAll('.person').forEach(p => {
                if (p.textContent.trim() === name) {
                    p.style.backgroundColor = '#e8f4f8';
                    p.style.fontWeight = 'normal';
                }
            });
        });
        
        // Add tooltip with person information
        person.setAttribute('title', `Person: ${name} (Click to see all mentions)`);
        
        person.addEventListener('click', function() {
            highlightAllMentions(name, 'person');
        });
    });
    
    // Similar functionality for places
    const placeNames = document.querySelectorAll('.place');
    placeNames.forEach(place => {
        const name = place.textContent.trim();
        
        place.addEventListener('mouseenter', function() {
            document.querySelectorAll('.place').forEach(p => {
                if (p.textContent.trim() === name) {
                    p.style.backgroundColor = '#e6ccff';
                    p.style.fontWeight = 'bold';
                }
            });
        });
        
        place.addEventListener('mouseleave', function() {
            document.querySelectorAll('.place').forEach(p => {
                if (p.textContent.trim() === name) {
                    p.style.backgroundColor = '#f0e8f8';
                    p.style.fontWeight = 'normal';
                }
            });
        });
        
        place.setAttribute('title', `Ort: ${name} (Click to see all mentions)`);
        
        place.addEventListener('click', function() {
            highlightAllMentions(name, 'place');
        });
    });
    
    // Function to highlight all mentions of a name
    function highlightAllMentions(name, type) {
        // Clear previous highlights
        document.querySelectorAll('.highlighted-mention').forEach(el => {
            el.classList.remove('highlighted-mention');
        });
        
        // Highlight all mentions
        document.querySelectorAll(`.${type}`).forEach(element => {
            if (element.textContent.trim() === name) {
                element.classList.add('highlighted-mention');
                element.scrollIntoView({
                    behavior: 'smooth',
                    block: 'center'
                });
            }
        });
        
        // Remove highlights after 5 seconds
        setTimeout(() => {
            document.querySelectorAll('.highlighted-mention').forEach(el => {
                el.classList.remove('highlighted-mention');
            });
        }, 5000);
    }
    
    // Add search functionality
    addSearchFeature();
    
    // Add entry counter
    addEntryCounter();
    
    // Make editorial notes expandable
    makeEditorialNotesExpandable();
});

function addSearchFeature() {
    const nav = document.querySelector('nav ul');
    if (nav) {
        const searchLi = document.createElement('li');
        const searchInput = document.createElement('input');
        searchInput.type = 'text';
        searchInput.placeholder = 'Suche im Tagebuch...';
        searchInput.style.padding = '0.5rem';
        searchInput.style.borderRadius = '3px';
        searchInput.style.border = '1px solid #ddd';
        
        searchLi.appendChild(searchInput);
        nav.appendChild(searchLi);
        
        searchInput.addEventListener('input', function() {
            const searchTerm = this.value.toLowerCase();
            const entries = document.querySelectorAll('.entry');
            
            entries.forEach(entry => {
                const text = entry.textContent.toLowerCase();
                if (searchTerm === '' || text.includes(searchTerm)) {
                    entry.style.display = 'block';
                } else {
                    entry.style.display = 'none';
                }
            });
        });
    }
}

function addEntryCounter() {
    const entriesSection = document.querySelector('#entries h2');
    if (entriesSection) {
        const entryCount = document.querySelectorAll('.entry').length;
        entriesSection.textContent += ` (${entryCount} Einträge)`;
    }
}

function makeEditorialNotesExpandable() {
    const editorialNotes = document.querySelectorAll('.editorial-note');
    editorialNotes.forEach(note => {
        note.style.cursor = 'pointer';
        note.addEventListener('click', function() {
            const title = this.getAttribute('title');
            if (title) {
                alert(title);
            }
        });
    });
}

// Add CSS for highlighted mentions
const style = document.createElement('style');
style.textContent = `
    .highlighted-mention {
        background-color: #ffeb3b !important;
        padding: 2px 4px !important;
        border-radius: 3px !important;
        box-shadow: 0 0 5px rgba(255, 235, 59, 0.7) !important;
        animation: highlight-pulse 1s ease-in-out infinite alternate;
    }
    
    @keyframes highlight-pulse {
        from { transform: scale(1); }
        to { transform: scale(1.05); }
    }
`;
document.head.appendChild(style);