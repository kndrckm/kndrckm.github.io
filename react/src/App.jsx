import { useState, useEffect } from 'react';
import Navbar from './components/Navbar';
import Footer from './components/Footer';
import HomePage from './pages/HomePage';
import ProjectPage from './pages/ProjectPage';
import './App.css'; // Import CSS if needed

export default function App() {
  const [currentView, setView] = useState('home');
  const [selectedProject, setSelectedProject] = useState(null);
  const [isTransitioning, setIsTransitioning] = useState(false);
  const [pendingView, setPendingView] = useState(null);
  const [pendingProject, setPendingProject] = useState(null);

  // Expansion Animation State
  const [expansion, setExpansion] = useState(null); // { rect, image }
  const [isExpanded, setIsExpanded] = useState(false);
  const [isOverlayFading, setIsOverlayFading] = useState(false);

  const handleProjectClick = (slug, rect) => {
    // Check if this is the Highlight card click (Kavling 12 with rect)
    if (slug === 'kavling-12' && rect) {
      // Use standard percentages for target to match ProjectPage structure exactly
      // Position absolute relative to document body (which matches ProjectPage flow)
      setExpansion({
        rect,
        image: '/assets/projects/kavling12_1.webp',
        // No calculated pixels needed for absolute, use pure percents/rem to match CSS
      });
      setPendingView('project');
      setPendingProject(slug);

      // Scroll to top smoothly to accompany the movement
      window.scrollTo({ top: 0, behavior: 'smooth' });

      // Trigger expansion animation
      setTimeout(() => {
        setIsExpanded(true);
      }, 50);

      // Wait for animation to finish then switch view
      setTimeout(() => {
        setView('project');
        setSelectedProject(slug);

        // Ensure we are at top (instant)
        window.scrollTo(0, 0);

        // Start fade out of overlay to reveal ProjectPage underneath seamlessly
        // Give React a frame to render ProjectPage first
        setTimeout(() => {
          setIsOverlayFading(true);

          // Unmount overlay after fade completes
          setTimeout(() => {
            setExpansion(null);
            setIsExpanded(false);
            setIsOverlayFading(false);
          }, 600); // 600ms fade out duration
        }, 100); // 100ms buffer for render
      }, 800); // 800ms match CSS transition
      return;
    }

    // Default fade transition
    setIsTransitioning(true);
    setPendingView('project');
    setPendingProject(slug);
  };

  const handleHomeClick = () => {
    setIsTransitioning(true);
    setPendingView('home');
    setPendingProject(null);
  };

  // Default Fade Transition Effect
  useEffect(() => {
    if (isTransitioning && pendingView) {
      const timer = setTimeout(() => {
        setView(pendingView);
        setSelectedProject(pendingProject);
        window.scrollTo(0, 0);

        setTimeout(() => {
          setIsTransitioning(false);
          setPendingView(null);
          setPendingProject(null);
        }, 50);
      }, 300);

      return () => clearTimeout(timer);
    }
  }, [isTransitioning, pendingView, pendingProject]);

  return (
    <>
      <Navbar onHomeClick={handleHomeClick} isHomePage={currentView === 'home'} />

      {/* Expansion Overlay */}
      {expansion && (
        <div
          style={{
            position: 'absolute', // Revert to absolute to match content width (excluding scrollbar)
            // Start: rect + scrollY for absolute positioning
            // End: 0, 0 for top-left of document
            top: isExpanded ? '0' : `${expansion.rect.top + window.scrollY}px`,
            left: isExpanded ? '0' : `${expansion.rect.left + window.scrollX}px`,
            width: isExpanded ? '100%' : `${expansion.rect.width}px`,
            height: isExpanded ? '100vh' : `${expansion.rect.height}px`,
            borderRadius: isExpanded ? '0' : '2.5rem',
            overflow: 'hidden',
            zIndex: 9999,
            opacity: isOverlayFading ? 0 : 1, // CROSSFADE
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
          {/* Overlay gradient to match style */}
          <div className="absolute inset-0 bg-gradient-to-t from-black/60 via-transparent to-transparent pointer-events-none"></div>
        </div>
      )}

      <main
        style={{
          opacity: isTransitioning ? 0 : 1,
          transform: isTransitioning ? 'translateY(20px)' : 'translateY(0)',
          transition: 'opacity 0.3s ease, transform 0.3s ease',
          minHeight: '100vh',
          // visibility: expansion && isExpanded ? 'hidden' : 'visible' 
          // REMOVED: Keep visible so ProjectPage pre-renders behind overlay
        }}
      >
        {currentView === 'home' && (
          <HomePage onProjectClick={handleProjectClick} />
        )}
        {currentView === 'project' && selectedProject && (
          <ProjectPage
            slug={selectedProject}
            onHomeClick={handleHomeClick}
            skipHeroAnimation={!!expansion}
          />
        )}
      </main>

      <Footer />
    </>
  );
}
