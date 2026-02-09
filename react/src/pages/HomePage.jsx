import { useEffect, useRef } from 'react';

// Raw project data for carousel
const rawProjectData = [
    {
        title: "Kavling 12",
        location: "Batam, Indonesia",
        category: "Residential",
        image: "/assets/projects/kavling12_1.webp",
        video: "/assets/kavling12.mp4",
        focus: "object-[50%_center]",
        slug: "kavling-12"
    },
    {
        title: "A home",
        location: "Bogor, Indonesia",
        category: "Residential",
        image: "/assets/projects/ahome_1.webp",
        video: "/assets/ahome.mp4",
        focus: "object-[50%_center]",
        slug: "a-home"
    },
    {
        title: "Boarding House",
        location: "Yogyakarta, Indonesia",
        category: "Commercial",
        image: "https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?q=80&w=2600",
        focus: "object-[50%_center]",
        slug: "boarding-house"
    },
    {
        title: "Private Villa",
        location: "Bali, Indonesia",
        category: "Hospitality",
        image: "https://images.unsplash.com/photo-1600585154340-be6161a56a0c?q=80&w=2600",
        focus: "object-[50%_center]",
        slug: "private-villa"
    }
];

// CV HTML content
const cvHTML = `
<div class="site-container">
    <div class="flex flex-col md:flex-row justify-between items-start md:items-end mb-10 md:mb-16 gap-6 reveal-text">
        <div>
            <span class="text-[10px] md:text-xs font-bold tracking-[0.3em] text-secondary uppercase mb-4 block">Professional Background</span>
            <h2 class="text-4xl md:text-6xl font-black text-primary tracking-tight uppercase">Curriculum Vitae</h2>
        </div>
        <a href="/assets/CV_Kendrick.pdf" target="_blank" class="nav-glass btn-animate inline-flex items-center gap-2 bg-primary text-white px-6 py-3 rounded-full text-sm font-bold hover:bg-accent transition-colors shadow-lg cursor-pointer">
            <i data-lucide="download" class="w-4 h-4"></i>Download CV
        </a>
    </div>
    <div class="grid grid-cols-1 lg:grid-cols-12 gap-6 items-start">
        <div class="lg:col-span-8 bg-white rounded-[2rem] md:rounded-[3rem] p-8 md:p-16 border border-black/5 shadow-ios-card">
            <div class="flex items-center gap-3 mb-12 reveal-text">
                <i data-lucide="briefcase" class="w-5 h-5 text-accent"></i>
                <h3 class="text-xs font-bold uppercase tracking-widest text-secondary">Experience</h3>
            </div>
            <div class="space-y-0 timeline-container">
                <div class="exp-item relative pl-10 pb-12 group cursor-pointer border-l-2 border-zinc-100 last:border-0 last:pb-0 reveal-text">
                    <div class="hidden md:flex absolute -left-28 top-0 w-20 h-20 bg-white rounded-2xl border border-black/5 shadow-ios-card items-center justify-center opacity-0 group-hover:opacity-100 transition-all duration-500 transform group-hover:translate-x-2 z-10 overflow-hidden">
                        <img src="/assets/companies/logo-amf.svg" class="w-full h-full object-contain" alt="AMF Logo">
                    </div>
                    <div class="absolute -left-[9px] top-2 w-4 h-4 rounded-full bg-white border-2 border-zinc-200 group-hover:bg-accent group-hover:border-accent transition-all duration-300"></div>
                    <div class="flex flex-col md:flex-row md:items-center justify-between gap-2">
                        <h4 class="text-2xl font-black text-primary tracking-tight">Project Architect</h4>
                        <span class="text-xs font-black text-accent uppercase tracking-widest bg-blue-50 px-3 py-1 rounded-full w-fit">2025</span>
                    </div>
                    <p class="text-secondary font-bold mt-1">PT Agies Mitra Faathir — Batam, Indonesia</p>
                    <div class="exp-details">
                        <ul class="list-disc list-outside ml-4 space-y-3 text-secondary text-[15px] font-medium leading-relaxed">
                            <li>Review consultant designs to ensure compliance with regulations, standards, and drawing quality.</li>
                            <li>Provide design alternatives integrating financial forecasting and ROI considerations.</li>
                            <li>Manage budget planning (RAB) and pricing proposals, optimizing costs while accommodating client expectations.</li>
                            <li>Curate and present architectural material options, supporting client decisions and strengthening trust.</li>
                        </ul>
                    </div>
                </div>
                <div class="exp-item relative pl-10 pb-12 group cursor-pointer border-l-2 border-zinc-100 last:border-0 last:pb-0">
                    <div class="hidden md:flex absolute -left-28 top-0 w-20 h-20 bg-white rounded-2xl border border-black/5 shadow-ios-card items-center justify-center opacity-0 group-hover:opacity-100 transition-all duration-500 transform group-hover:translate-x-2 z-10 overflow-hidden">
                        <img src="/assets/companies/logo-shimizu.svg" class="w-full h-full object-contain" alt="Shimizu Logo">
                    </div>
                    <div class="absolute -left-[9px] top-2 w-4 h-4 rounded-full bg-white border-2 border-zinc-200 group-hover:bg-accent group-hover:border-accent transition-all duration-300"></div>
                    <div class="flex flex-col md:flex-row md:items-center justify-between gap-2">
                        <h4 class="text-2xl font-black text-primary tracking-tight">BIM Engineer</h4>
                        <span class="text-xs font-bold text-secondary uppercase tracking-widest bg-zinc-100 px-3 py-1 rounded-full w-fit">2022 – 2024</span>
                    </div>
                    <p class="text-secondary font-bold mt-1">Shimizu-Adhi Karya CP201 Project — Jakarta</p>
                    <div class="exp-details">
                        <ul class="list-disc list-outside ml-4 space-y-3 text-secondary text-[15px] font-medium leading-relaxed">
                            <li>Contributed in BIM coordination to align design and construction, minimizing discrepancies and reducing costs.</li>
                            <li>Streamlined information management across Architecture, MEP, and Civil teams to improve efficiency.</li>
                            <li>Developed BIM data for Jakarta MRT CP201 Monas – Thamrin Station, the central hub for future MRT intersections.</li>
                            <li>Delivered 3D scans and design data to support accurate on-site execution and reduce conflicts.</li>
                        </ul>
                    </div>
                </div>
                <div class="exp-item relative pl-10 pb-12 group cursor-pointer border-l-2 border-zinc-100 last:border-0 last:pb-0">
                    <div class="hidden md:flex absolute -left-28 top-0 w-20 h-20 bg-white rounded-2xl border border-black/5 shadow-ios-card items-center justify-center opacity-0 group-hover:opacity-100 transition-all duration-500 transform group-hover:translate-x-2 z-10 overflow-hidden">
                        <img src="/assets/companies/logo-pdw.svg" class="w-full h-full object-contain" alt="PDW Logo">
                    </div>
                    <div class="absolute -left-[9px] top-2 w-4 h-4 rounded-full bg-white border-2 border-zinc-200 group-hover:bg-accent group-hover:border-accent transition-all duration-300"></div>
                    <div class="flex flex-col md:flex-row md:items-center justify-between gap-2">
                        <h4 class="text-2xl font-black text-primary tracking-tight">Architect (Internship)</h4>
                        <span class="text-xs font-bold text-secondary uppercase tracking-widest bg-zinc-100 px-3 py-1 rounded-full w-fit">2021 – 2022</span>
                    </div>
                    <p class="text-secondary font-bold mt-1">PT Pandega Desain Wehirama — Jakarta</p>
                    <div class="exp-details">
                        <ul class="list-disc list-outside ml-4 space-y-3 text-secondary text-[15px] font-medium leading-relaxed">
                            <li>Supported design development for data center, resort, monumental building, and corporate offices.</li>
                            <li>Assisted senior architects with design revisions, cost calculations, and project presentations.</li>
                            <li>Prepared concept decks and visual materials to strengthen client engagement during project pitches.</li>
                        </ul>
                    </div>
                </div>
                <div class="exp-item relative pl-10 group cursor-pointer border-l-2 border-zinc-100 last:border-0 pb-1 reveal-text">
                    <div class="hidden md:flex absolute -left-28 top-0 w-20 h-20 bg-white rounded-2xl border border-black/5 shadow-ios-card items-center justify-center opacity-0 group-hover:opacity-100 transition-all duration-500 transform group-hover:translate-x-2 z-10 overflow-hidden">
                        <img src="/assets/companies/logo-dpe.svg" class="w-full h-full object-contain" alt="DPE Logo">
                    </div>
                    <div class="absolute -left-[9px] top-2 w-4 h-4 rounded-full bg-white border-2 border-zinc-200 group-hover:bg-accent group-hover:border-accent transition-all duration-300"></div>
                    <div class="flex flex-col md:flex-row md:items-center justify-between gap-2">
                        <h4 class="text-2xl font-black text-primary tracking-tight">Green Building Consultant</h4>
                        <span class="text-xs font-bold text-secondary uppercase tracking-widest bg-zinc-100 px-3 py-1 rounded-full w-fit">2019 – 2020</span>
                    </div>
                    <p class="text-secondary font-bold mt-1">Desain Performa Energi — Yogyakarta</p>
                    <div class="exp-details">
                        <ul class="list-disc list-outside ml-4 space-y-3 text-secondary text-[15px] font-medium leading-relaxed">
                            <li>Prepared green building certification through design simulations, compliance analysis, and sustainability reporting.</li>
                            <li>Researched and modeled net-zero energy strategies for Indonesia's new capital city (IKN) masterplan.</li>
                            <li>Collaborated with multidisciplinary teams to integrate sustainable solutions into large-scale projects.</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
        <div class="lg:col-span-4 space-y-6">
            <div class="bg-white rounded-[2rem] p-8 md:p-10 border border-black/5 shadow-ios-card">
                <div class="flex items-center gap-3 mb-8">
                    <i data-lucide="graduation-cap" class="w-5 h-5 text-accent"></i>
                    <h3 class="text-xs font-bold uppercase tracking-widest text-secondary">Education</h3>
                </div>
                <div class="space-y-8">
                    <div>
                        <h4 class="font-bold text-primary leading-tight text-lg">Master of Business Administration (M.B.A.)</h4>
                        <p class="text-secondary text-sm">Universitas Gadjah Mada</p>
                        <p class="text-xs font-bold text-accent mt-1 tracking-tighter uppercase">2023 – 2025</p>
                    </div>
                    <div>
                        <h4 class="font-bold text-primary leading-tight text-lg">Professional Degree – Architecture (Ar.)</h4>
                        <p class="text-secondary text-sm">Universitas Gadjah Mada</p>
                        <p class="text-xs font-bold text-accent mt-1 tracking-tighter uppercase">2021 – 2022</p>
                    </div>
                    <div>
                        <h4 class="font-bold text-primary leading-tight text-lg">Bachelor of Engineering – Architecture</h4>
                        <p class="text-secondary text-sm">Universitas Gadjah Mada</p>
                        <p class="text-xs font-bold text-accent mt-1 tracking-tighter uppercase">2015 – 2019</p>
                    </div>
                </div>
            </div>
            <div class="bg-white rounded-[2rem] p-8 md:p-10 border border-black/5 shadow-ios-card">
                <div class="flex items-center gap-3 mb-8">
                    <i data-lucide="cpu" class="w-5 h-5 text-accent"></i>
                    <h3 class="text-xs font-bold uppercase tracking-widest text-secondary">Tools & Skills</h3>
                </div>
                <div class="flex flex-wrap gap-2 overflow-visible">
                    <span class="px-3 py-1.5 bg-primary text-white rounded-lg text-[10px] font-bold uppercase tracking-tighter">Ms. Office</span>
                    <span class="px-3 py-1.5 bg-primary text-white rounded-lg text-[10px] font-bold uppercase tracking-tighter">Revit</span>
                    <span class="px-3 py-1.5 bg-primary text-white rounded-lg text-[10px] font-bold uppercase tracking-tighter">AutoCAD</span>
                    <span class="px-3 py-1.5 bg-primary text-white rounded-lg text-[10px] font-bold uppercase tracking-tighter">Rhino</span>
                    <span class="px-3 py-1.5 bg-primary text-white rounded-lg text-[10px] font-bold uppercase tracking-tighter">SketchUp</span>
                    <span class="px-3 py-1.5 bg-primary text-white rounded-lg text-[10px] font-bold uppercase tracking-tighter">3Ds Max</span>
                    <span class="px-3 py-1.5 bg-primary text-white rounded-lg text-[10px] font-bold uppercase tracking-tighter">Naviswork</span>
                    <span class="px-3 py-1.5 bg-primary text-white rounded-lg text-[10px] font-bold uppercase tracking-tighter">Stata 17</span>
                    <span class="px-3 py-1.5 bg-primary text-white rounded-lg text-[10px] font-bold uppercase tracking-tighter">SPSS</span>
                    <span class="px-3 py-1.5 bg-primary text-white rounded-lg text-[10px] font-bold uppercase tracking-tighter">Adobe Suite</span>
                    <div class="w-full h-px border-t border-dashed border-gray-200 my-1"></div>
                    <span class="px-3 py-1.5 bg-accent text-white rounded-lg text-[10px] font-bold uppercase tracking-tighter">Team Coordination</span>
                    <span class="px-3 py-1.5 bg-accent text-white rounded-lg text-[10px] font-bold uppercase tracking-tighter">Stakeholder Management</span>
                    <span class="px-3 py-1.5 bg-accent text-white rounded-lg text-[10px] font-bold uppercase tracking-tighter">Data Analysis</span>
                    <span class="px-3 py-1.5 bg-accent text-white rounded-lg text-[10px] font-bold uppercase tracking-tighter">Strategic Thinking</span>
                </div>
            </div>
            <div class="bg-white rounded-[2rem] p-8 md:p-10 border border-black/5 shadow-ios-card">
                <div class="flex items-center gap-3 mb-8">
                    <i data-lucide="trophy" class="w-5 h-5 text-accent"></i>
                    <h3 class="text-xs font-bold uppercase tracking-widest text-secondary">Achievement</h3>
                </div>
                <div class="space-y-6 text-sm">
                    <div class="flex gap-4">
                        <span class="font-black text-primary">2025</span>
                        <p class="text-secondary font-medium tracking-tight">Secure Architecture Package – PT. AMF, Batam</p>
                    </div>
                    <div class="flex gap-4">
                        <span class="font-black text-primary">2021</span>
                        <p class="text-secondary font-medium tracking-tight">2nd Place – Jati Campus Design Competition</p>
                    </div>
                    <div class="flex gap-4">
                        <span class="font-black text-primary">2019</span>
                        <p class="text-secondary font-medium tracking-tight">4th Place – IKN Masterplan Design Competition</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
`;

export default function HomePage({ onProjectClick }) {
    const carouselRef = useRef(null);
    const heroCanvasRef = useRef(null);
    const onProjectClickRef = useRef(onProjectClick);

    // Keep ref updated
    useEffect(() => {
        onProjectClickRef.current = onProjectClick;
    }, [onProjectClick]);

    useEffect(() => {
        // Init Lucide icons
        if (window.lucide) window.lucide.createIcons();

        // Hero parallax & overlay
        const overlay = document.getElementById('scroll-overlay');
        const vid1 = document.getElementById('hero-img');
        const vid2 = document.getElementById('hero-img-next');
        const heroForeground = document.getElementById('hero-foreground');

        const handleScroll = () => {
            const scrollY = window.scrollY;
            const windowHeight = window.innerHeight;

            if (scrollY <= windowHeight) {
                [vid1, vid2].forEach(v => {
                    if (v) v.style.transform = `translateY(-${scrollY * 0.05}px) scale(1.2)`;
                });

                if (heroForeground) {
                    const opacity = Math.max(1 - (scrollY / (windowHeight * 0.4)), 0);
                    heroForeground.style.opacity = opacity;
                    heroForeground.style.visibility = opacity <= 0.01 ? 'hidden' : 'visible';
                }

                if (overlay) {
                    overlay.style.opacity = Math.min(scrollY / (windowHeight * 0.8), 0.9);
                }
            } else {
                if (heroForeground) {
                    heroForeground.style.opacity = 0;
                    heroForeground.style.visibility = 'hidden';
                }
            }
        };

        window.addEventListener('scroll', handleScroll);

        // Initial visibility
        if (heroForeground) {
            heroForeground.style.opacity = 1;
            heroForeground.style.visibility = 'visible';
        }

        // Hero Spotlight Canvas
        const canvas = heroCanvasRef.current;
        const container = document.getElementById('hero-spotlight-container');
        if (canvas && container) {
            const ctx = canvas.getContext('2d');
            let mouseX = -1000, mouseY = -1000;
            let isVisible = true;
            let animationId;

            const resize = () => {
                const rect = container.getBoundingClientRect();
                const dpr = window.devicePixelRatio || 1;
                canvas.width = rect.width * dpr;
                canvas.height = rect.height * dpr;
                ctx.scale(dpr, dpr);
                canvas.style.width = `${rect.width}px`;
                canvas.style.height = `${rect.height}px`;
            };
            resize();
            window.addEventListener('resize', resize);

            const handleMouseMove = (e) => {
                const rect = container.getBoundingClientRect();
                if (e.clientY >= rect.top && e.clientY <= rect.bottom) {
                    mouseX = e.clientX - rect.left;
                    mouseY = e.clientY - rect.top;
                } else {
                    mouseX = -1000;
                    mouseY = -1000;
                }
            };
            document.addEventListener('mousemove', handleMouseMove);

            const draw = () => {
                if (isVisible) {
                    const dpr = window.devicePixelRatio || 1;
                    const width = canvas.width / dpr;
                    const height = canvas.height / dpr;
                    ctx.clearRect(0, 0, width, height);

                    if (mouseX !== -1000 && mouseY !== -1000) {
                        const g = ctx.createRadialGradient(mouseX, mouseY, 0, mouseX, mouseY, 500);
                        g.addColorStop(0, 'rgba(255,255,255,0.3)');
                        g.addColorStop(1, 'rgba(255,255,255,0)');
                        ctx.fillStyle = g;
                        ctx.fillRect(0, 0, width, height);
                    }
                }
                animationId = requestAnimationFrame(draw);
            };
            draw();
        }

        // Scroll Reveal
        const revealElements = document.querySelectorAll('.reveal-text:not(.revealed):not(.revealed-no-anim)');
        const revealObserver = new IntersectionObserver((entries, observer) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add('revealed');
                    observer.unobserve(entry.target);
                }
            });
        }, { threshold: 0.1, rootMargin: "0px 0px -50px 0px" });

        revealElements.forEach(el => {
            const rect = el.getBoundingClientRect();
            if (rect.top < window.innerHeight) {
                el.classList.add('revealed-no-anim');
                setTimeout(() => el.classList.add('revealed'), 10);
            } else {
                revealObserver.observe(el);
            }
        });

        // CV expand logic (desktop only)
        document.querySelectorAll('.exp-item').forEach(item => {
            const reveal = () => {
                if (window.innerWidth >= 1024) {
                    item.classList.add('is-revealed');
                }
            };
            item.addEventListener('mouseenter', reveal);
            item.addEventListener('click', reveal);
        });

        // Carousel logic
        initCarousel();

        return () => {
            window.removeEventListener('scroll', handleScroll);
        };
    }, []);

    const initCarousel = () => {
        const container = carouselRef.current;
        if (!container) return;

        // Build carousel HTML
        const halfLength = Math.ceil(rawProjectData.length / 2);
        const row1Data = rawProjectData.slice(0, halfLength);
        const row2Data = rawProjectData.slice(halfLength);

        const duplicateCount = window.innerWidth < 768 ? 3 : 8;
        const duplicateArray = (arr, times) => {
            let result = [];
            for (let i = 0; i < times; i++) result = result.concat(arr);
            return result;
        };

        const topItems = duplicateArray(row1Data, duplicateCount);
        const bottomItems = duplicateArray(row2Data, duplicateCount);

        let columnsHTML = '';
        const totalCols = topItems.length;

        const createCard = (project) => `
      <div class="project-card relative w-full h-[calc(50%-0.5rem)] overflow-hidden rounded-[1.5rem] cursor-pointer select-none pointer-events-auto group" data-slug="${project.slug}">
        <div class="block w-full h-full relative">
          <img src="${project.image}" loading="lazy" draggable="false"
            class="absolute h-full w-full object-cover ${project.focus || 'object-center'} transition-transform duration-1000 group-hover:scale-105" 
            alt="${project.title}">
          ${project.video ? `
            <video data-src="${project.video}" preload="none" muted loop playsinline
              class="absolute inset-0 w-full h-full object-cover opacity-0 transition-opacity duration-500 group-hover:opacity-100 z-10 pointer-events-none">
            </video>
          ` : ''}
          <div class="absolute inset-0 project-gradient opacity-60 transition-opacity duration-500 hover:opacity-40 z-20"></div>
          <div class="absolute top-4 left-4 md:top-5 md:left-5 z-30">
            <span class="px-3 py-1 bg-white/90 backdrop-blur-md rounded-full text-[8px] md:text-[10px] font-black uppercase tracking-widest text-primary shadow-sm">
              ${project.category || 'Architecture'}
            </span>
          </div>
          <div class="absolute bottom-0 left-0 p-4 md:p-6 w-full text-white z-30">
            <span class="block text-[8px] md:text-[10px] font-bold tracking-[0.2em] text-white/70 uppercase mb-1">
              ${project.location}
            </span>
            <div class="flex items-end justify-between">
              <h3 class="text-lg md:text-2xl font-black uppercase tracking-tighter leading-[0.9] max-w-[80%]">
                ${project.title}
              </h3>
              <div class="w-8 h-8 md:w-10 md:h-10 rounded-full bg-white text-black flex items-center justify-center opacity-0 scale-75 group-hover:opacity-100 group-hover:scale-100 transition-all duration-300 delay-100">
                <i data-lucide="arrow-up-right" class="w-4 h-4 md:w-5 md:h-5"></i>
              </div>
            </div>
          </div>
        </div>
      </div>
    `;

        for (let i = 0; i < totalCols; i++) {
            const itemTop = topItems[i];
            const itemBottom = bottomItems[i] || topItems[i];

            columnsHTML += `<div class="project-column flex flex-col gap-4 h-full shrink-0 w-[280px] md:w-[350px] snap-center">`;
            columnsHTML += createCard(itemTop);
            columnsHTML += createCard(itemBottom);
            columnsHTML += `</div>`;
        }

        container.innerHTML = `<div class="project-carousel-wrapper flex gap-4 h-[400px] md:h-[550px] overflow-x-auto snap-x snap-mandatory scroll-smooth no-scrollbar">${columnsHTML}</div>`;

        // Video hover - Global
        document.querySelectorAll('.project-card').forEach(card => {
            const video = card.querySelector('video');
            if (video) {
                card.addEventListener('mouseenter', () => {
                    if (!video.src && video.dataset.src) {
                        video.src = video.dataset.src;
                        video.load();
                    }
                    video.play().catch(e => console.log('Video play failed:', e));
                });
                card.addEventListener('mouseleave', () => {
                    video.pause();
                    video.currentTime = 0;
                });
            }
        });

        // Initial scroll position
        const carouselWrapper = container.querySelector('.project-carousel-wrapper');
        if (carouselWrapper) {
            setTimeout(() => {
                carouselWrapper.scrollLeft = carouselWrapper.scrollWidth / 3;
            }, 150);
        }

        // Button controls
        const prevBtn = document.getElementById('prev-slide');
        const nextBtn = document.getElementById('next-slide');
        const prevBtnMobile = document.getElementById('prev-slide-mobile');
        const nextBtnMobile = document.getElementById('next-slide-mobile');
        const cardWidth = 360;

        if (prevBtn) prevBtn.addEventListener('click', () => {
            carouselWrapper?.scrollBy({ left: -cardWidth, behavior: 'smooth' });
        });

        if (nextBtn) nextBtn.addEventListener('click', () => {
            carouselWrapper?.scrollBy({ left: cardWidth, behavior: 'smooth' });
        });

        // Mobile buttons
        if (prevBtnMobile) prevBtnMobile.addEventListener('click', () => {
            carouselWrapper?.scrollBy({ left: -cardWidth, behavior: 'smooth' });
        });

        if (nextBtnMobile) nextBtnMobile.addEventListener('click', () => {
            carouselWrapper?.scrollBy({ left: cardWidth, behavior: 'smooth' });
        });

        // Refresh icons
        if (window.lucide) window.lucide.createIcons();
    };

    return (
        <>
            {/* HERO SECTION */}
            <section id="hero" className="relative w-full h-[100vh] bg-black">
                <div className="w-full h-full">
                    <div id="hero-spotlight-container" className="hero-container sticky top-0 h-screen overflow-hidden group">
                        <div id="video-wrapper" className="absolute inset-0 w-full h-full">
                            <video id="hero-img" autoPlay muted playsInline poster="/assets/hero.webp"
                                className="absolute top-0 w-full h-[120vh] object-cover transition-transform duration-75 ease-out will-change-transform scale-[1.2] brightness-[0.6] z-10">
                                <source src="/assets/hero.mp4" type="video/mp4" />
                            </video>
                            <video id="hero-img-next" muted playsInline preload="auto"
                                className="absolute top-0 w-full h-[120vh] object-cover transition-transform duration-75 ease-out will-change-transform scale-[1.2] brightness-[0.6] opacity-0 z-0">
                                <source src="/assets/hero2.mp4" type="video/mp4" />
                            </video>
                        </div>
                        <div id="scroll-overlay" className="absolute inset-0 z-10"></div>
                        <canvas ref={heroCanvasRef} id="hero-spotlight-canvas"
                            className="absolute inset-0 w-full h-full z-30 pointer-events-none mix-blend-overlay"></canvas>
                    </div>

                    <div className="fixed inset-0 flex flex-col justify-end pb-12 md:pb-20 z-0 pointer-events-none">
                        <div id="hero-foreground"
                            className="select-none w-[88%] md:w-[90%] 2xl:w-[85%] max-w-[1800px] mx-auto pointer-events-auto will-change-transform">
                            <div className="flex flex-col md:flex-row md:items-end justify-between gap-6 w-full">
                                <div className="flex-1 min-w-0 md:pr-8">
                                    <div className="flex items-center gap-4 mb-4">
                                        <span className="text-[12px] md:text-sm font-bold tracking-[0.1em] text-white uppercase">
                                            Residential & Commercial Design
                                        </span>
                                        <div className="h-[3px] w-12 md:w-24 bg-white"></div>
                                    </div>
                                    <h1 className="text-[11vw] sm:text-[9vw] md:text-[7vw] lg:text-[6rem] font-extrabold leading-[0.8] tracking-tighter uppercase mb-6">
                                        <span className="text-white">KEND</span><span className="text-white/40">.</span>
                                        <span className="text-white">DESIGN</span><span className="text-white/40">.</span>
                                        <span className="block text-white/40 tracking-[-0.04em]">STUDIO</span>
                                    </h1>
                                    <p id="hero-para" className="text-white/60 text-base md:text-lg max-w-2xl font-medium leading-relaxed mb-0">
                                        Crafting spaces that breathe. Where light meets structure and form follows emotion.
                                    </p>
                                </div>
                                <button
                                    onClick={() => onProjectClick && onProjectClick('kavling-12')}
                                    className="group shrink-0 inline-flex items-center gap-3 bg-white/10 hover:bg-white/20 backdrop-blur-md border border-white/20 text-white px-6 py-3 rounded-full text-sm font-bold transition-all duration-300 hover:scale-105 md:mb-1 cursor-pointer">
                                    View Featured Project
                                    <div className="w-8 h-8 rounded-full bg-white/20 flex items-center justify-center transition-all duration-300 group-hover:bg-accent group-hover:rotate-45">
                                        <i data-lucide="arrow-up-right" className="w-4 h-4"></i>
                                    </div>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            {/* HIGHLIGHT EXPERIMENT SECTION */}
            <section id="highlight" className="relative z-10 bg-[#EDEFF2] pt-24 md:pt-48 pb-12">
                <div className="site-container">
                    <div className="mb-10 md:mb-14 reveal-text">
                        <span className="text-[10px] md:text-xs font-bold tracking-[0.2em] text-secondary uppercase mb-2 block">
                            Highlight
                        </span>
                        <h2 className="text-4xl md:text-6xl font-black text-primary tracking-tight uppercase">Latest Work</h2>
                    </div>

                    <div className="w-full h-[500px] md:h-[650px] reveal-text">
                        <div
                            className="project-card relative w-full h-full overflow-hidden rounded-[2.5rem] cursor-pointer select-none pointer-events-auto group shadow-2xl"
                            onClick={(e) => {
                                const rect = e.currentTarget.getBoundingClientRect();
                                onProjectClick && onProjectClick('kavling-12', rect);
                            }}
                        >
                            <div className="block w-full h-full relative">
                                <img src="/assets/projects/kavling12_1.webp" loading="lazy" draggable="false"
                                    className="absolute h-full w-full object-cover object-[50%_center] transition-transform duration-1000 group-hover:scale-105"
                                    alt="Kavling 12" />

                                <div className="absolute inset-0 project-gradient opacity-60 transition-opacity duration-500 hover:opacity-40 z-20"></div>

                                <div className="absolute top-6 left-6 md:top-10 md:left-10 z-30">
                                    <span className="px-4 py-2 bg-white/90 backdrop-blur-md rounded-full text-[10px] md:text-xs font-black uppercase tracking-widest text-primary shadow-sm border border-white/40">
                                        Residential
                                    </span>
                                </div>

                                <div className="absolute bottom-0 left-0 p-8 md:p-12 w-full text-white z-30">
                                    <span className="block text-[10px] md:text-xs font-bold tracking-[0.2em] text-white/70 uppercase mb-3">
                                        Batam, Indonesia
                                    </span>
                                    <div className="flex items-end justify-between">
                                        <h3 className="text-3xl md:text-5xl font-black uppercase tracking-tighter leading-[0.9] max-w-[80%]">
                                            Kavling 12
                                        </h3>
                                        <div className="w-12 h-12 md:w-20 md:h-20 rounded-full bg-white text-black flex items-center justify-center opacity-0 scale-75 group-hover:opacity-100 group-hover:scale-100 transition-all duration-300 delay-100">
                                            <i data-lucide="arrow-up-right" className="w-6 h-6 md:w-8 md:h-8"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            {/* SCOPE SECTION */}
            <section id="scope" className="relative z-10 bg-[#EDEFF2] pt-24 md:pt-32 -scroll-mt-24">
                <div className="site-container">
                    <div className="mb-10 md:mb-14 reveal-text">
                        <span className="text-[10px] md:text-xs font-bold tracking-[0.2em] text-secondary uppercase mb-2 block">
                            Scope of work
                        </span>
                        <h2 className="text-4xl md:text-6xl font-black text-primary tracking-tight uppercase">Project Typology</h2>
                    </div>

                    <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                        <div className="relative w-full h-[200px] md:h-[240px] rounded-[2rem] overflow-hidden shadow-ios-card hover:shadow-ios-deep hover:scale-[1.02] transition-all duration-500 cursor-pointer reveal-text">
                            <img src="https://images.unsplash.com/photo-1600607686527-6fb886090705?q=80&w=1200"
                                className="absolute inset-0 w-full h-full object-cover" alt="Residential" />
                            <div className="absolute inset-0 bg-black/50"></div>
                            <div className="absolute bottom-0 left-0 p-6 md:p-8 w-full">
                                <div className="mb-3 text-white/90">
                                    <i data-lucide="home" className="w-8 h-8 stroke-[1.5]"></i>
                                </div>
                                <h3 className="text-2xl md:text-3xl font-black text-white uppercase mb-2 tracking-tighter">Residential</h3>
                                <p className="text-white/70 text-xs md:text-sm font-medium leading-relaxed">
                                    Private sanctuaries where architecture meets living.
                                </p>
                            </div>
                        </div>

                        <div className="relative w-full h-[200px] md:h-[240px] rounded-[2rem] overflow-hidden shadow-ios-card hover:shadow-ios-deep hover:scale-[1.02] transition-all duration-500 cursor-pointer reveal-text">
                            <img src="https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?q=80&w=1200"
                                className="absolute inset-0 w-full h-full object-cover" alt="Commercial" />
                            <div className="absolute inset-0 bg-black/50"></div>
                            <div className="absolute bottom-0 left-0 p-6 md:p-8 w-full">
                                <div className="mb-3 text-white/90">
                                    <i data-lucide="building-2" className="w-8 h-8 stroke-[1.5]"></i>
                                </div>
                                <h3 className="text-2xl md:text-3xl font-black text-white uppercase mb-2 tracking-tighter">Commercial</h3>
                                <p className="text-white/70 text-xs md:text-sm font-medium leading-relaxed">
                                    Environments designed for productivity and impact.
                                </p>
                            </div>
                        </div>

                        <div className="relative w-full h-[200px] md:h-[240px] rounded-[2rem] overflow-hidden shadow-ios-card hover:shadow-ios-deep hover:scale-[1.02] transition-all duration-500 cursor-pointer reveal-text">
                            <img src="https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?q=80&w=1200"
                                className="absolute inset-0 w-full h-full object-cover" alt="Interior" />
                            <div className="absolute inset-0 bg-black/50"></div>
                            <div className="absolute bottom-0 left-0 p-6 md:p-8 w-full">
                                <div className="mb-3 text-white/90">
                                    <i data-lucide="armchair" className="w-8 h-8 stroke-[1.5]"></i>
                                </div>
                                <h3 className="text-2xl md:text-3xl font-black text-white uppercase mb-2 tracking-tighter">Interior</h3>
                                <p className="text-white/70 text-xs md:text-sm font-medium leading-relaxed">
                                    Curating atmospheres through texture, light, and flow.
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            {/* FEATURED PROJECTS */}
            <section id="portfolio" className="relative z-10 bg-[#EDEFF2] pt-24 md:pt-48 -scroll-mt-24">
                <div className="site-container">
                    <div className="mb-10 flex items-end justify-between md:mb-14 reveal-text">
                        <div className="flex flex-col gap-4">
                            <span className="text-[10px] md:text-xs font-bold tracking-[0.2em] text-secondary uppercase mb-2 block">
                                Selected Works
                            </span>
                            <h2 className="text-4xl md:text-6xl font-black text-primary tracking-tight uppercase">Featured Projects</h2>
                        </div>

                        <div className="hidden shrink-0 gap-3 md:flex">
                            <button id="prev-slide"
                                className="p-4 rounded-full border border-black/10 hover:bg-black hover:text-white transition-all duration-300 disabled:opacity-30 active:scale-95">
                                <i data-lucide="arrow-left" className="w-6 h-6"></i>
                            </button>
                            <button id="next-slide"
                                className="p-4 rounded-full border border-black/10 hover:bg-black hover:text-white transition-all duration-300 disabled:opacity-30 active:scale-95">
                                <i data-lucide="arrow-right" className="w-6 h-6"></i>
                            </button>
                        </div>
                    </div>
                </div>

                <div className="w-full relative overflow-hidden">
                    {/* Carousel Fade Edge Hints */}
                    <div className="carousel-fade-left absolute top-0 bottom-0 left-0 w-20 bg-gradient-to-r from-[#EDEFF2] to-transparent z-20 pointer-events-none"></div>
                    <div className="carousel-fade-right absolute top-0 bottom-0 right-0 w-20 bg-gradient-to-l from-[#EDEFF2] to-transparent z-20 pointer-events-none"></div>

                    <div ref={carouselRef} id="project-carousel"
                        className="flex flex-col overflow-x-auto scroll-smooth no-scrollbar pb-8 reveal-text">
                        {/* Skeleton placeholder - replaced by JS */}
                        <div id="carousel-skeleton" className="flex flex-col h-[400px] md:h-[550px] gap-4 px-[6%]">
                            <div className="flex gap-4 h-1/2">
                                <div className="skeleton shrink-0 w-[280px] md:w-[350px] h-full"></div>
                                <div className="skeleton shrink-0 w-[280px] md:w-[350px] h-full"></div>
                                <div className="skeleton shrink-0 w-[280px] md:w-[350px] h-full"></div>
                            </div>
                            <div className="flex gap-4 h-1/2">
                                <div className="skeleton shrink-0 w-[280px] md:w-[350px] h-full"></div>
                                <div className="skeleton shrink-0 w-[280px] md:w-[350px] h-full"></div>
                                <div className="skeleton shrink-0 w-[280px] md:w-[350px] h-full"></div>
                            </div>
                        </div>
                    </div>

                    {/* Mobile Navigation Buttons */}
                    <div className="flex md:hidden justify-center gap-4 mt-2 mb-8 sticky bottom-6 z-30 pointer-events-none">
                        <button id="prev-slide-mobile" aria-label="Previous project slide"
                            className="p-4 bg-white/80 backdrop-blur-md rounded-full shadow-lg text-primary pointer-events-auto active:scale-95 transition-transform border border-white/20">
                            <i data-lucide="arrow-left" className="w-6 h-6"></i>
                        </button>
                        <button id="next-slide-mobile" aria-label="Next project slide"
                            className="p-4 bg-white/80 backdrop-blur-md rounded-full shadow-lg text-primary pointer-events-auto active:scale-95 transition-transform border border-white/20">
                            <i data-lucide="arrow-right" className="w-6 h-6"></i>
                        </button>
                    </div>

                    <div className="site-container">
                        <div className="flex justify-center gap-2 mt-4" id="carousel-dots"></div>
                    </div>
                </div>
            </section>

            {/* CV SECTION */}
            <section id="cv" className="pt-24 md:pt-48 bg-transparent -scroll-mt-0"
                dangerouslySetInnerHTML={{ __html: cvHTML }}>
            </section>
        </>
    );
}
