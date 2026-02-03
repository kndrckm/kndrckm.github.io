// This file protects your data from being lost during UI updates
const cvHTML = `
<div class="max-w-[1400px] mx-auto">
    <div class="flex flex-col md:flex-row justify-between items-start md:items-end mb-16 gap-6">
        <div>
            <span class="text-[10px] md:text-xs font-bold tracking-[0.3em] text-secondary uppercase mb-4 block">Professional Background</span>
            <h2 class="text-4xl md:text-6xl font-black text-primary tracking-tight">Curriculum Vitae</h2>
        </div>
        <a href="#" class="btn-animate inline-flex items-center gap-2 bg-primary text-white px-6 py-3 rounded-full text-sm font-bold hover:bg-accent transition-colors">
            <i data-lucide="download" class="w-4 h-4"></i> Download PDF
        </a>
    </div>

    <div class="grid grid-cols-1 lg:grid-cols-12 gap-6 items-start">
        <!-- SIDEBAR -->
        <div class="lg:col-span-4 space-y-6">
            <!-- Education -->
            <div class="bg-white rounded-[2rem] p-8 md:p-10 border border-black/5 shadow-ios-card">
                <div class="flex items-center gap-3 mb-8">
                    <i data-lucide="graduation-cap" class="w-5 h-5 text-accent"></i>
                    <h3 class="text-xs font-bold uppercase tracking-widest text-secondary">Education</h3>
                </div>
                <div class="space-y-8">
                    <div>
                        <h4 class="font-bold text-primary leading-tight text-lg">Master of Business Administration (M.B.A.)</h4>
                        <p class="text-secondary text-sm">Universitas Gadjah Mada</p>
                        <p class="text-xs font-bold text-accent mt-1 tracking-tighter">2023 – 2025</p>
                    </div>
                    <div>
                        <h4 class="font-bold text-primary leading-tight text-lg">Professional Degree – Architecture (Ar.)</h4>
                        <p class="text-secondary text-sm">Universitas Gadjah Mada</p>
                        <p class="text-xs font-bold text-accent mt-1 tracking-tighter">2021 – 2022</p>
                    </div>
                    <div>
                        <h4 class="font-bold text-primary leading-tight text-lg">Bachelor of Engineering – Architecture</h4>
                        <p class="text-secondary text-sm">Universitas Gadjah Mada</p>
                        <p class="text-xs font-bold text-accent mt-1 tracking-tighter">2015 – 2019</p>
                    </div>
                </div>
            </div>

            <!-- Tools & Skills -->
            <div class="bg-white rounded-[2rem] p-8 md:p-10 border border-black/5 shadow-ios-card">
                <div class="flex items-center gap-3 mb-8">
                    <i data-lucide="cpu" class="w-5 h-5 text-accent"></i>
                    <h3 class="text-xs font-bold uppercase tracking-widest text-secondary">Tools & Skills</h3>
                </div>
                <div class="flex flex-wrap gap-2">
                    <span class="px-3 py-1.5 bg-primary rounded-lg text-[10px] font-bold text-white uppercase tracking-tighter">Ms. Office</span>
                    <span class="px-3 py-1.5 bg-primary rounded-lg text-[10px] font-bold text-white uppercase tracking-tighter">Revit</span>
                    <span class="px-3 py-1.5 bg-primary rounded-lg text-[10px] font-bold text-white uppercase tracking-tighter">AutoCAD</span>
                    <span class="px-3 py-1.5 bg-primary rounded-lg text-[10px] font-bold text-white uppercase tracking-tighter">Rhino</span>
                    <span class="px-3 py-1.5 bg-primary rounded-lg text-[10px] font-bold text-white uppercase tracking-tighter">SketchUp</span>
                    <span class="px-3 py-1.5 bg-primary rounded-lg text-[10px] font-bold text-white uppercase tracking-tighter">3Ds Max</span>
                    <span class="px-3 py-1.5 bg-primary rounded-lg text-[10px] font-bold text-white uppercase tracking-tighter">Stata 17</span>
                    <span class="px-3 py-1.5 bg-accent rounded-lg text-[10px] font-bold text-white uppercase tracking-tighter">Stakeholder Management</span>
                    <span class="px-3 py-1.5 bg-accent rounded-lg text-[10px] font-bold text-white uppercase tracking-tighter">Data Analysis</span>
                    <span class="px-3 py-1.5 bg-accent rounded-lg text-[10px] font-bold text-white uppercase tracking-tighter">Strategic Thinking</span>
                </div>
            </div>

            <!-- Achievement -->
            <div class="bg-white rounded-[2rem] p-8 md:p-10 border border-black/5 shadow-ios-card">
                <div class="flex items-center gap-3 mb-8">
                    <i data-lucide="trophy" class="w-5 h-5 text-accent"></i>
                    <h3 class="text-xs font-bold uppercase tracking-widest text-secondary">Achievement</h3>
                </div>
                <div class="space-y-6">
                    <div class="flex gap-4"><span class="font-black text-primary text-sm">2025</span><p class="text-secondary font-medium tracking-tight text-sm">Secure Architecture Package – Pentagon Apt.</p></div>
                    <div class="flex gap-4"><span class="font-black text-primary text-sm">2021</span><p class="text-secondary font-medium tracking-tight text-sm">2nd Place – Campus Design Comp.</p></div>
                    <div class="flex gap-4"><span class="font-black text-primary text-sm">2019</span><p class="text-secondary font-medium tracking-tight text-sm">4th Place – IKN Masterplan Design</p></div>
                </div>
            </div>
        </div>

        <!-- EXPERIENCE COLUMN -->
        <div class="lg:col-span-8 bg-white rounded-[2rem] md:rounded-[3rem] p-8 md:p-16 border border-black/5 shadow-ios-card">
            <div class="flex items-center gap-3 mb-12">
                <i data-lucide="briefcase" class="w-5 h-5 text-accent"></i>
                <h3 class="text-xs font-bold uppercase tracking-widest text-secondary">Experience</h3>
            </div>
            <div class="space-y-0">
                <!-- Job 1 -->
                <div class="exp-item relative pl-10 pb-12 group cursor-pointer border-l-2 border-zinc-100 last:border-0 last:pb-0">
                    <div class="absolute -left-[9px] top-0 w-4 h-4 rounded-full bg-white border-2 border-zinc-200 group-hover:bg-accent group-hover:border-accent transition-all duration-300"></div>
                    <div class="flex flex-col md:flex-row md:items-center justify-between gap-2">
                        <h4 class="text-2xl font-black text-primary tracking-tight">Project Architect</h4>
                        <span class="text-xs font-black text-accent uppercase tracking-widest bg-blue-50 px-3 py-1 rounded-full">2025 – Present</span>
                    </div>
                    <p class="text-secondary font-bold mt-1">PT Agies Mitra Faathir — Batam</p>
                    <div class="exp-details">
                        <ul class="list-disc list-outside ml-4 mt-4 space-y-3 text-secondary text-sm font-medium leading-relaxed">
                            <li>Review consultant designs for compliance and quality.</li>
                            <li>Provide design alternatives integrating financial forecasting and ROI.</li>
                            <li>Curate architectural material options supporting client decisions.</li>
                        </ul>
                    </div>
                </div>
                <!-- Job 2 -->
                <div class="exp-item relative pl-10 pb-12 group cursor-pointer border-l-2 border-zinc-100 last:border-0 last:pb-0">
                    <div class="absolute -left-[9px] top-0 w-4 h-4 rounded-full bg-white border-2 border-zinc-200 group-hover:bg-accent group-hover:border-accent transition-all duration-300"></div>
                    <div class="flex flex-col md:flex-row md:items-center justify-between gap-2">
                        <h4 class="text-2xl font-black text-primary tracking-tight">BIM Engineer</h4>
                        <span class="text-xs font-bold text-secondary uppercase tracking-widest bg-zinc-100 px-3 py-1 rounded-full">2022 – 2024</span>
                    </div>
                    <p class="text-secondary font-bold mt-1">Shimizu-Adhi Karya CP201 — Jakarta</p>
                    <div class="exp-details">
                        <ul class="list-disc list-outside ml-4 mt-4 space-y-3 text-secondary text-sm font-medium leading-relaxed">
                            <li>BIM coordination for Jakarta MRT CP201 Monas Station.</li>
                            <li>Streamlined information management across multi-disciplinary teams.</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
`;