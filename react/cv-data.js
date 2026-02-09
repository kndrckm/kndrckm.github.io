const cvHTML = `
<div class="site-container">
    
    <div class="flex flex-col md:flex-row justify-between items-start md:items-end mb-10 md:mb-16 gap-6 reveal-text">
        <div>
            <span class="text-[10px] md:text-xs font-bold tracking-[0.3em] text-secondary uppercase mb-4 block">Professional Background</span>
            <h2 class="text-4xl md:text-6xl font-black text-primary tracking-tight uppercase">Curriculum Vitae</h2>
        </div>

        <a href="assets/CV_Kendrick.pdf" target="_blank" class="nav-glass btn-animate inline-flex items-center gap-2 bg-primary text-white px-6 py-3 rounded-full text-sm font-bold hover:bg-accent transition-colors shadow-lg cursor-pointer">
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
                
                <!-- Item 1 -->
                <div class="exp-item relative pl-10 pb-12 group cursor-pointer border-l-2 border-zinc-100 last:border-0 last:pb-0 reveal-text">
                    <!-- Logo Hover (Desktop only) -->
                    <div class="hidden md:flex absolute -left-28 top-0 w-20 h-20 bg-white rounded-2xl border border-black/5 shadow-ios-card items-center justify-center opacity-0 group-hover:opacity-100 transition-all duration-500 transform group-hover:translate-x-2 z-10 overflow-hidden">
                        <img src="assets/companies/logo-amf.svg" class="w-full h-full object-contain" alt="AMF Logo">
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

                <!-- Item 2 -->
                <div class="exp-item relative pl-10 pb-12 group cursor-pointer border-l-2 border-zinc-100 last:border-0 last:pb-0">
                    <div class="hidden md:flex absolute -left-28 top-0 w-20 h-20 bg-white rounded-2xl border border-black/5 shadow-ios-card items-center justify-center opacity-0 group-hover:opacity-100 transition-all duration-500 transform group-hover:translate-x-2 z-10 overflow-hidden">
                        <img src="assets/companies/logo-shimizu.svg" class="w-full h-full object-contain" alt="Shimizu Logo">
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

                <!-- Item 3 -->
                <div class="exp-item relative pl-10 pb-12 group cursor-pointer border-l-2 border-zinc-100 last:border-0 last:pb-0">
                    <div class="hidden md:flex absolute -left-28 top-0 w-20 h-20 bg-white rounded-2xl border border-black/5 shadow-ios-card items-center justify-center opacity-0 group-hover:opacity-100 transition-all duration-500 transform group-hover:translate-x-2 z-10 overflow-hidden">
                        <img src="assets/companies/logo-pdw.svg" class="w-full h-full object-contain" alt="PDW Logo">
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

                <!-- Item 4 -->
                <div class="exp-item relative pl-10 group cursor-pointer border-l-2 border-zinc-100 last:border-0 pb-1 reveal-text">
                    <div class="hidden md:flex absolute -left-28 top-0 w-20 h-20 bg-white rounded-2xl border border-black/5 shadow-ios-card items-center justify-center opacity-0 group-hover:opacity-100 transition-all duration-500 transform group-hover:translate-x-2 z-10 overflow-hidden">
                        <img src="assets/companies/logo-dpe.svg" class="w-full h-full object-contain" alt="DPE Logo">
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
                            <li>Researched and modeled net-zero energy strategies for Indonesia’s new capital city (IKN) masterplan.</li>
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
                    <!-- Ms. Office -->
                    <div class="group relative flex justify-center">
                        <span class="px-3 py-1.5 bg-primary text-white rounded-lg text-[10px] font-bold uppercase tracking-tighter cursor-help">Ms. Office</span>
                        <div class="absolute bottom-full mb-3 w-max px-3 py-2 bg-white rounded-xl shadow-xl opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-all duration-300 transform group-hover:-translate-y-1 z-[60] pointer-events-none border border-black/5">
                            <div class="flex items-center gap-2">
                                <div class="w-6 h-6 rounded-lg bg-[#EA3C00] flex items-center justify-center text-white text-[10px] font-bold shadow-sm">O</div>
                                <span class="text-primary text-[10px] font-bold whitespace-nowrap">Microsoft Office</span>
                            </div>
                            <div class="absolute -bottom-1 left-1/2 -translate-x-1/2 w-2 h-2 bg-white rotate-45 border-b border-r border-black/5"></div>
                        </div>
                    </div>
                    <!-- Revit -->
                    <div class="group relative flex justify-center">
                        <span class="px-3 py-1.5 bg-primary text-white rounded-lg text-[10px] font-bold uppercase tracking-tighter cursor-help">Revit</span>
                        <div class="absolute bottom-full mb-3 w-max px-3 py-2 bg-white rounded-xl shadow-xl opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-all duration-300 transform group-hover:-translate-y-1 z-[60] pointer-events-none border border-black/5">
                            <div class="flex items-center gap-2">
                                <div class="w-6 h-6 rounded-lg bg-[#0696D7] flex items-center justify-center text-white text-[10px] font-bold shadow-sm">R</div>
                                <span class="text-primary text-[10px] font-bold whitespace-nowrap">Autodesk Revit</span>
                            </div>
                            <div class="absolute -bottom-1 left-1/2 -translate-x-1/2 w-2 h-2 bg-white rotate-45 border-b border-r border-black/5"></div>
                        </div>
                    </div>
                    <!-- AutoCAD -->
                    <div class="group relative flex justify-center">
                        <span class="px-3 py-1.5 bg-primary text-white rounded-lg text-[10px] font-bold uppercase tracking-tighter cursor-help">AutoCAD</span>
                        <div class="absolute bottom-full mb-3 w-max px-3 py-2 bg-white rounded-xl shadow-xl opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-all duration-300 transform group-hover:-translate-y-1 z-[60] pointer-events-none border border-black/5">
                            <div class="flex items-center gap-2">
                                <div class="w-6 h-6 rounded-lg bg-[#E31C2D] flex items-center justify-center text-white text-[10px] font-bold shadow-sm">A</div>
                                <span class="text-primary text-[10px] font-bold whitespace-nowrap">Autodesk AutoCAD</span>
                            </div>
                            <div class="absolute -bottom-1 left-1/2 -translate-x-1/2 w-2 h-2 bg-white rotate-45 border-b border-r border-black/5"></div>
                        </div>
                    </div>
                    <!-- Rhino -->
                    <div class="group relative flex justify-center">
                        <span class="px-3 py-1.5 bg-primary text-white rounded-lg text-[10px] font-bold uppercase tracking-tighter cursor-help">Rhino</span>
                        <div class="absolute bottom-full mb-3 w-max px-3 py-2 bg-white rounded-xl shadow-xl opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-all duration-300 transform group-hover:-translate-y-1 z-[60] pointer-events-none border border-black/5">
                            <div class="flex items-center gap-2">
                                <div class="w-6 h-6 rounded-lg bg-black flex items-center justify-center text-white text-[10px] font-bold shadow-sm">R</div>
                                <span class="text-primary text-[10px] font-bold whitespace-nowrap">Rhinoceros 3D</span>
                            </div>
                            <div class="absolute -bottom-1 left-1/2 -translate-x-1/2 w-2 h-2 bg-white rotate-45 border-b border-r border-black/5"></div>
                        </div>
                    </div>
                    <!-- SketchUp -->
                    <div class="group relative flex justify-center">
                        <span class="px-3 py-1.5 bg-primary text-white rounded-lg text-[10px] font-bold uppercase tracking-tighter cursor-help">SketchUp</span>
                        <div class="absolute bottom-full mb-3 w-max px-3 py-2 bg-white rounded-xl shadow-xl opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-all duration-300 transform group-hover:-translate-y-1 z-[60] pointer-events-none border border-black/5">
                            <div class="flex items-center gap-2">
                                <div class="w-6 h-6 rounded-lg bg-[#005F9E] flex items-center justify-center text-white text-[10px] font-bold shadow-sm">S</div>
                                <span class="text-primary text-[10px] font-bold whitespace-nowrap">Trimble SketchUp</span>
                            </div>
                            <div class="absolute -bottom-1 left-1/2 -translate-x-1/2 w-2 h-2 bg-white rotate-45 border-b border-r border-black/5"></div>
                        </div>
                    </div>
                    <!-- 3Ds Max -->
                    <div class="group relative flex justify-center">
                        <span class="px-3 py-1.5 bg-primary text-white rounded-lg text-[10px] font-bold uppercase tracking-tighter cursor-help">3Ds Max</span>
                        <div class="absolute bottom-full mb-3 w-max px-3 py-2 bg-white rounded-xl shadow-xl opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-all duration-300 transform group-hover:-translate-y-1 z-[60] pointer-events-none border border-black/5">
                            <div class="flex items-center gap-2">
                                <div class="w-6 h-6 rounded-lg bg-[#F0B326] flex items-center justify-center text-black text-[10px] font-bold shadow-sm">3</div>
                                <span class="text-primary text-[10px] font-bold whitespace-nowrap">Autodesk 3ds Max</span>
                            </div>
                            <div class="absolute -bottom-1 left-1/2 -translate-x-1/2 w-2 h-2 bg-white rotate-45 border-b border-r border-black/5"></div>
                        </div>
                    </div>
                    <!-- Naviswork -->
                    <div class="group relative flex justify-center">
                        <span class="px-3 py-1.5 bg-primary text-white rounded-lg text-[10px] font-bold uppercase tracking-tighter cursor-help">Naviswork</span>
                        <div class="absolute bottom-full mb-3 w-max px-3 py-2 bg-white rounded-xl shadow-xl opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-all duration-300 transform group-hover:-translate-y-1 z-[60] pointer-events-none border border-black/5">
                            <div class="flex items-center gap-2">
                                <div class="w-6 h-6 rounded-lg bg-[#088544] flex items-center justify-center text-white text-[10px] font-bold shadow-sm">N</div>
                                <span class="text-primary text-[10px] font-bold whitespace-nowrap">Autodesk Navisworks</span>
                            </div>
                            <div class="absolute -bottom-1 left-1/2 -translate-x-1/2 w-2 h-2 bg-white rotate-45 border-b border-r border-black/5"></div>
                        </div>
                    </div>
                    <!-- Stata 17 -->
                    <div class="group relative flex justify-center">
                        <span class="px-3 py-1.5 bg-primary text-white rounded-lg text-[10px] font-bold uppercase tracking-tighter cursor-help">Stata 17</span>
                        <div class="absolute bottom-full mb-3 w-max px-3 py-2 bg-white rounded-xl shadow-xl opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-all duration-300 transform group-hover:-translate-y-1 z-[60] pointer-events-none border border-black/5">
                            <div class="flex items-center gap-2">
                                <div class="w-6 h-6 rounded-lg bg-[#1A5F90] flex items-center justify-center text-white text-[10px] font-bold shadow-sm">S</div>
                                <span class="text-primary text-[10px] font-bold whitespace-nowrap">StataCorp Stata 17</span>
                            </div>
                            <div class="absolute -bottom-1 left-1/2 -translate-x-1/2 w-2 h-2 bg-white rotate-45 border-b border-r border-black/5"></div>
                        </div>
                    </div>
                    <!-- SPSS -->
                    <div class="group relative flex justify-center">
                        <span class="px-3 py-1.5 bg-primary text-white rounded-lg text-[10px] font-bold uppercase tracking-tighter cursor-help">SPSS</span>
                        <div class="absolute bottom-full mb-3 w-max px-3 py-2 bg-white rounded-xl shadow-xl opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-all duration-300 transform group-hover:-translate-y-1 z-[60] pointer-events-none border border-black/5">
                            <div class="flex items-center gap-2">
                                <div class="w-6 h-6 rounded-lg bg-[#1E3F92] flex items-center justify-center text-white text-[10px] font-bold shadow-sm">S</div>
                                <span class="text-primary text-[10px] font-bold whitespace-nowrap">IBM SPSS</span>
                            </div>
                            <div class="absolute -bottom-1 left-1/2 -translate-x-1/2 w-2 h-2 bg-white rotate-45 border-b border-r border-black/5"></div>
                        </div>
                    </div>
                    <!-- Adobe Suite -->
                    <div class="group relative flex justify-center">
                        <span class="px-3 py-1.5 bg-primary text-white rounded-lg text-[10px] font-bold uppercase tracking-tighter cursor-help">Adobe Suite</span>
                        <div class="absolute bottom-full mb-3 w-max px-3 py-2 bg-white rounded-xl shadow-xl opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-all duration-300 transform group-hover:-translate-y-1 z-[60] pointer-events-none border border-black/5">
                            <div class="flex items-center gap-2">
                                <div class="w-6 h-6 rounded-lg bg-[#FF0000] flex items-center justify-center text-white text-[10px] font-bold shadow-sm">Cc</div>
                                <span class="text-primary text-[10px] font-bold whitespace-nowrap">Adobe Creative Cloud</span>
                            </div>
                            <div class="absolute -bottom-1 left-1/2 -translate-x-1/2 w-2 h-2 bg-white rotate-45 border-b border-r border-black/5"></div>
                        </div>
                    </div>

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