import { useState, useRef } from 'react';

export default function ProjectCard({ project, onProjectClick }) {
    const [isHovering, setIsHovering] = useState(false);
    const videoRef = useRef(null);

    const handleMouseEnter = () => {
        setIsHovering(true);
        if (videoRef.current && project.video) {
            videoRef.current.play().catch(() => { });
        }
    };

    const handleMouseLeave = () => {
        setIsHovering(false);
        if (videoRef.current) {
            videoRef.current.pause();
            videoRef.current.currentTime = 0;
        }
    };

    const handleClick = (e) => {
        e.preventDefault();
        if (onProjectClick) onProjectClick(project.slug);
    };

    return (
        <a
            href="#"
            onClick={handleClick}
            className="project-card relative w-full h-full overflow-hidden rounded-[1.5rem] cursor-pointer select-none group block"
            onMouseEnter={handleMouseEnter}
            onMouseLeave={handleMouseLeave}
        >
            {/* Image */}
            <img
                src={project.image}
                alt={project.title}
                className="absolute inset-0 w-full h-full object-cover transition-transform duration-1000 group-hover:scale-105"
            />

            {/* Video Overlay */}
            {project.video && (
                <video
                    ref={videoRef}
                    src={project.video}
                    muted
                    loop
                    playsInline
                    className={`absolute inset-0 w-full h-full object-cover transition-opacity duration-500 z-10 ${isHovering ? 'opacity-100' : 'opacity-0'}`}
                />
            )}

            {/* Gradient Overlay */}
            <div className="absolute inset-0 bg-gradient-to-t from-black/70 via-black/20 to-transparent z-20" />

            {/* Category Badge */}
            <div className="absolute top-4 left-4 md:top-5 md:left-5 z-30">
                <span className="px-3 py-1 bg-white/90 backdrop-blur-md rounded-full text-[8px] md:text-[10px] font-black uppercase tracking-widest text-[#1D1D1F] shadow-sm">
                    {project.category}
                </span>
            </div>

            {/* Info */}
            <div className="absolute bottom-0 left-0 p-4 md:p-6 w-full text-white z-30">
                <span className="block text-[8px] md:text-[10px] font-bold tracking-[0.2em] text-white/70 uppercase mb-1">
                    {project.location}
                </span>
                <div className="flex items-end justify-between">
                    <h3 className="text-lg md:text-2xl font-black uppercase tracking-tighter leading-[0.9] max-w-[80%]">
                        {project.title}
                    </h3>
                    <div className="w-8 h-8 md:w-10 md:h-10 rounded-full bg-white text-black flex items-center justify-center opacity-0 scale-75 group-hover:opacity-100 group-hover:scale-100 transition-all duration-300 delay-100">
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                            <path d="M7 7h10v10" /><path d="M7 17 17 7" />
                        </svg>
                    </div>
                </div>
            </div>
        </a>
    );
}
