import { useState, useEffect } from 'react';
import Navbar from './components/Navbar';
import Footer from './components/Footer';
import HomePage from './pages/HomePage';
import ProjectPage from './pages/ProjectPage';
import './App.css';

export default function App() {
  const [selectedProject, setSelectedProject] = useState(null);

  // Expansion Animation State
  const [expansion, setExpansion] = useState(null); // { rect, image }
  const [isExpanded, setIsExpanded] = useState(false);
  const [isOverlayFading, setIsOverlayFading] = useState(false);
  const [showProjectContent, setShowProjectContent] = useState(false);

  // Lock body scroll when project overlay is active
  useEffect(() => {
    if (selectedProject) {
      document.body.style.overflow = 'hidden';
    } else {
      document.body.style.overflow = '';
    }
    return () => {
      document.body.style.overflow = '';
    };
  }, [selectedProject]);

  const handleProjectClick = (slug, rect) => {
    // Check if this is the Highlight card click (Kavling 12 with rect)
    if (slug === 'kavling-12' && rect) {
      setExpansion({
        rect,
        image: '/assets/projects/kavling12_1.webp',
      });

      // Trigger expansion animation
      setTimeout(() => {
        setIsExpanded(true);
      }, 50);

      // Wait for animation to finish then show project overlay
      setTimeout(() => {
        setSelectedProject(slug);
        setShowProjectContent(true);

        // Start fade out of expansion overlay
        setTimeout(() => {
          setIsOverlayFading(true);

          // Unmount expansion overlay after fade completes
          setTimeout(() => {
            setExpansion(null);
            setIsExpanded(false);
            setIsOverlayFading(false);
          }, 600);
        }, 100);
      }, 800);
      return;
    }

    // Default: Just show project overlay (no fancy animation for other projects)
    setSelectedProject(slug);
    setShowProjectContent(true);
  };

  const handleCloseProject = () => {
    // Fade out project overlay
    setShowProjectContent(false);

    // After fade, clear selection
    setTimeout(() => {
      setSelectedProject(null);
    }, 300);
  };

  return (
    <>
      <Navbar
        onHomeClick={handleCloseProject}
        isHomePage={!selectedProject}
      />

      {/* Expansion Animation Overlay */}
      {expansion && (
        <div
          style={{
            position: 'fixed', // Fixed for viewport alignment
            top: isExpanded ? '0' : `${expansion.rect.top}px`,
            left: isExpanded ? '0' : `${expansion.rect.left}px`,
            width: isExpanded ? '100vw' : `${expansion.rect.width}px`,
            height: isExpanded ? '100vh' : `${expansion.rect.height}px`,
            borderRadius: isExpanded ? '0' : '2.5rem',
            overflow: 'hidden',
            zIndex: 9999,
            opacity: isOverlayFading ? 0 : 1,
            transition: 'top 0.8s cubic-bezier(0.65, 0, 0.35, 1), left 0.8s cubic-bezier(0.65, 0, 0.35, 1), width 0.8s cubic-bezier(0.65, 0, 0.35, 1), height 0.8s cubic-bezier(0.65, 0, 0.35, 1), border-radius 0.8s cubic-bezier(0.65, 0, 0.35, 1), opacity 0.6s ease',
            boxShadow: '0 25px 50px -12px rgba(0, 0, 0, 0.25)'
          }}
        >
          <img
            src={expansion.image}
            alt="Expanding Project"
            style={{
              width: '100%',
              height: '100%',
              objectFit: 'cover'
            }}
          />
          <div className="absolute inset-0 bg-gradient-to-t from-black/60 via-transparent to-transparent pointer-events-none"></div>
        </div>
      )}

      {/* Project Overlay Modal */}
      {selectedProject && (
        <div
          className="fixed inset-0 z-[100] overflow-y-auto bg-[#EDEFF2]"
          style={{
            opacity: showProjectContent ? 1 : 0,
            transition: 'opacity 0.3s ease'
          }}
        >
          <ProjectPage
            slug={selectedProject}
            onHomeClick={handleCloseProject}
            skipHeroAnimation={!!expansion || true}
          />
          <Footer />
        </div>
      )}

      {/* Home Page - Always Mounted */}
      <main style={{ minHeight: '100vh' }}>
        <HomePage onProjectClick={handleProjectClick} />
      </main>

      <Footer />
    </>
  );
}
