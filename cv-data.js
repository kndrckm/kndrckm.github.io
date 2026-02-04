const cvHTML = `
<div class="site-container">
    
    <div class="flex flex-col md:flex-row justify-between items-start md:items-end mb-10 md:mb-16 gap-6">
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
            <div class="flex items-center gap-3 mb-12">
                <i data-lucide="briefcase" class="w-5 h-5 text-accent"></i>
                <h3 class="text-xs font-bold uppercase tracking-widest text-secondary">Experience</h3>
            </div>

            <div class="space-y-0 timeline-container">
                
                <div class="exp-item relative pl-10 pb-12 group cursor-pointer border-l-2 border-zinc-100 last:border-0 last:pb-0">
                    <div class="absolute -left-[9px] top-0 w-4 h-4 rounded-full bg-white border-2 border-zinc-200 group-hover:bg-accent group-hover:border-accent transition-all duration-300"></div>
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
                    <div class="absolute -left-[9px] top-0 w-4 h-4 rounded-full bg-white border-2 border-zinc-200 group-hover:bg-accent group-hover:border-accent transition-all duration-300"></div>
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
                    <div class="absolute -left-[9px] top-0 w-4 h-4 rounded-full bg-white border-2 border-zinc-200 group-hover:bg-accent group-hover:border-accent transition-all duration-300"></div>
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

                <div class="exp-item relative pl-10 group cursor-pointer border-l-2 border-zinc-100 last:border-0 pb-1">
                    <div class="absolute -left-[9px] top-0 w-4 h-4 rounded-full bg-white border-2 border-zinc-200 group-hover:bg-accent group-hover:border-accent transition-all duration-300"></div>
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
                <div class="flex flex-wrap gap-2">
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