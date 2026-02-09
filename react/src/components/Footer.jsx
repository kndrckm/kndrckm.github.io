import { useEffect, useRef } from 'react';

export default function Footer() {
    const canvasRef = useRef(null);
    const containerRef = useRef(null);

    useEffect(() => {
        // Footer Year
        const yearSpan = document.getElementById('footer-year');
        if (yearSpan) yearSpan.textContent = new Date().getFullYear();

        // Init Lucide icons
        if (window.lucide) window.lucide.createIcons();

        // Footer Spotlight
        const canvas = canvasRef.current;
        const container = containerRef.current;
        if (!canvas || !container) return;

        const ctx = canvas.getContext('2d');
        let mouseX = -1000, mouseY = -1000;
        let isVisible = false;
        let animationId;

        const resize = () => {
            const rect = container.getBoundingClientRect();
            canvas.width = rect.width;
            canvas.height = rect.height;
        };
        window.addEventListener('resize', resize);
        resize();

        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => isVisible = entry.isIntersecting);
        }, { threshold: 0 });
        observer.observe(container);

        const handleMouseMove = (e) => {
            const rect = container.getBoundingClientRect();
            mouseX = e.clientX - rect.left;
            mouseY = e.clientY - rect.top;
        };
        container.addEventListener('mousemove', handleMouseMove);

        const draw = () => {
            if (isVisible) {
                ctx.clearRect(0, 0, canvas.width, canvas.height);
                if (mouseX !== -1000) {
                    const g = ctx.createRadialGradient(mouseX, mouseY, 0, mouseX, mouseY, 400);
                    g.addColorStop(0, 'rgba(255,255,255,0.4)');
                    g.addColorStop(1, 'rgba(255,255,255,0)');
                    ctx.fillStyle = g;
                    ctx.fillRect(0, 0, canvas.width, canvas.height);
                }
            }
            animationId = requestAnimationFrame(draw);
        };
        draw();

        // Text Rotator
        const textRotator = document.getElementById('text-rotator');
        const rotatorMask = document.getElementById('rotator-mask');
        let rotIndex = 0;
        let rotatorInterval;

        if (textRotator && rotatorMask) {
            const rotChildren = textRotator.children;
            const rotTotal = rotChildren.length - 1;

            const setWidth = (idx) => {
                if (rotChildren[idx]) rotatorMask.style.width = rotChildren[idx].offsetWidth + 'px';
            };

            setWidth(0);
            document.fonts.ready.then(() => setWidth(rotIndex));

            rotatorInterval = setInterval(() => {
                rotIndex++;
                setWidth(rotIndex);
                textRotator.style.transition = 'transform 0.5s cubic-bezier(0.25, 1, 0.5, 1)';
                textRotator.style.transform = `translateY(calc(-${rotIndex} * 1.2em))`;

                if (rotIndex === rotTotal) {
                    setTimeout(() => {
                        textRotator.style.transition = 'none';
                        rotIndex = 0;
                        textRotator.style.transform = `translateY(0)`;
                        setWidth(0);
                    }, 500);
                }
            }, 3000);
        }

        return () => {
            window.removeEventListener('resize', resize);
            container.removeEventListener('mousemove', handleMouseMove);
            observer.disconnect();
            cancelAnimationFrame(animationId);
            if (rotatorInterval) clearInterval(rotatorInterval);
        };
    }, []);

    return (
        <section className="pt-12 md:pt-24 pb-0 w-full">
            <div
                ref={containerRef}
                id="footer-spotlight-container"
                className="vision-mesh-animated relative w-full overflow-hidden pt-16 pb-8 md:pt-24 md:pb-12 px-6 text-center shadow-[inset_0_20px_60px_-10px_rgba(0,0,0,0.6)] group"
            >
                <canvas
                    ref={canvasRef}
                    id="footer-spotlight-canvas"
                    className="absolute inset-0 w-full h-full z-0 pointer-events-none mix-blend-overlay"
                />

                <div className="relative z-10 flex flex-col items-center">
                    <h2 className="reveal-text text-4xl md:text-6xl font-medium text-white tracking-tighter mb-6 flex flex-col md:grid md:grid-cols-[1fr_auto_1fr] items-center gap-x-[0.25em] gap-y-1 w-full justify-center">
                        <span className="md:text-right">Have a</span>
                        <div
                            id="rotator-mask"
                            className="h-[1.2em] overflow-hidden relative grid place-items-center text-accent transition-all duration-500 ease-in-out md:mx-auto"
                        >
                            <div id="text-rotator" className="text-center w-max transform translate-y-0">
                                <span className="block h-[1.2em] leading-[1.2em] px-1">vision</span>
                                <span className="block h-[1.2em] leading-[1.2em] px-1">idea</span>
                                <span className="block h-[1.2em] leading-[1.2em] px-1">project</span>
                                <span className="block h-[1.2em] leading-[1.2em] px-1">question</span>
                                <span className="block h-[1.2em] leading-[1.2em] px-1">dream</span>
                                <span className="block h-[1.2em] leading-[1.2em] px-1">concept</span>
                                <span className="block h-[1.2em] leading-[1.2em] px-1">vision</span>
                            </div>
                        </div>
                        <span className="md:text-left">in mind?</span>
                    </h2>

                    <p className="reveal-text text-white/60 text-base md:text-xl font-light mb-10 italic">
                        Let's create something timeless together.
                    </p>

                    <a
                        href="https://wa.me/6281390200075"
                        target="_blank"
                        className="inline-flex items-center gap-5 bg-white text-primary pl-10 pr-3 py-3.5 rounded-full font-black text-xl transition-all duration-500 hover:scale-110 shadow-2xl group/btn mb-12"
                    >
                        Start a Project
                        <div className="bg-black rounded-full p-3 text-white transition-all duration-500 group-hover/btn:bg-accent group-hover/btn:rotate-45">
                            <i data-lucide="arrow-up-right" className="w-6 h-6"></i>
                        </div>
                    </a>

                    <div className="pt-0 flex flex-col items-center justify-center gap-6 max-w-6xl mx-auto reveal-text">
                        <div className="flex gap-6">
                            <a
                                href="https://linkedin.com/in/kendrick-marzuki"
                                target="_blank"
                                className="flex items-center gap-3 text-white/70 hover:text-white transition-all font-black text-sm hover:scale-105"
                            >
                                <div className="p-2 rounded-xl bg-white/10 hover:bg-[#0077B5] transition-colors">
                                    <i data-lucide="linkedin" className="w-4 h-4"></i>
                                </div>
                                LinkedIn
                            </a>
                        </div>
                        <p className="text-white/30 text-[10px] font-bold uppercase tracking-[0.2em]">
                            © <span id="footer-year"></span> KENDRICK MARZUKI
                        </p>
                    </div>
                </div>
            </div>
        </section>
    );
}
