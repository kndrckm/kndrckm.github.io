document.addEventListener("DOMContentLoaded", () => {
    document.body.classList.add('loaded');

    const openBtn = document.getElementById('open-btn');
    const invitationCard = document.getElementById('invitation-card');
    const surveyContainer = document.getElementById('survey-container');
    const finalContainer = document.getElementById('final-container');

    const questionText = document.getElementById('question-text');
    const optionsContainer = document.getElementById('options-container');
    const finalSummary = document.getElementById('final-summary');

    // --- Configuration ---
    const WEBHOOK_URL = "https://discord.com/api/webhooks/1471375539360235560/CrxtjoFgI8YpSWFsYoPD_Mym_MVJnHH4p-CejRjte2w2PIIUwrEyBW0OBDaIH9JXvbMQ";

    // --- Data: Destinations ---
    const phase1Spots = [
        // Heritage (A+A)
        { name: "Pecinan Glodok (Walking Tour)", region: "Barat", tags: ["AA", "AB", "BA"] },
        { name: "Petak Enam (Kuliner & Lampion)", region: "Barat", tags: ["AA", "AB"] },
        { name: "Kota Tua (Museum & Sepeda)", region: "Pusat", tags: ["AA", "CA"] },
        { name: "Setu Babakan (Danau Betawi)", region: "Selatan", tags: ["AA", "AB"] },
        { name: "Pura Aditya Jaya (Vibes Bali)", region: "Timur", tags: ["AA"] },

        // Seni/Buku (A+C)
        { name: "ISA Art Gallery (Pameran Seni)", region: "Pusat", tags: ["AC", "BC"] },
        { name: "Perpustakaan Jakarta Cikini", region: "Pusat", tags: ["AC", "BC"] },

        // Estetik/Floral (B+B)
        { name: "Coffee Dia (Picnic on Grass)", region: "Barat", tags: ["BB", "AB"] },
        { name: "Same Same Bakery (Pastry)", region: "Barat", tags: ["BB"] },
        { name: "ONNI House (Florist Cafe)", region: "Barat", tags: ["BB"] },
        { name: "Saputto Tebet (Tenang & Homey)", region: "Selatan", tags: ["BB", "BA"] },
        { name: "Kyō Coffee (Mini Kyoto)", region: "Timur", tags: ["BB"] },

        // Seni/Modern (B+C)
        { name: "Birubeeru Coffee (Art & Decor)", region: "Pusat", tags: ["BC", "BB"] },

        // Kriya/Wahana (C+C)
        { name: "Workshop Pottery Kota Tua", region: "Pusat", tags: ["CC", "AC"] },
        { name: "Sarinah Photobooth", region: "Pusat", tags: ["CC"] },
        { name: "LIT House (Meronce Beads)", region: "Selatan", tags: ["CC", "BC"] },
        { name: "Kopi Cat Cafe (Main Kucing)", region: "Selatan", tags: ["CC"] },
        { name: "Shoot Archery (Memanah)", region: "Selatan", tags: ["CC"] },
        { name: "J-Sky Ferris Wheel (Bianglala)", region: "Timur", tags: ["CC", "AC"] }
    ];

    const phase2Spots = [
        // Nusantara Klasik (A+A)
        { name: "Uma Oma Heritage", region: "Pusat", tags: ["AA"] },
        { name: "Kopi Tenong", region: "Timur", tags: ["AA"] },

        // Nusantara Taman (A+B)
        { name: "Mandira's Garden", region: "Selatan", tags: ["AB"] },
        { name: "Tuniang Bali Kemang", region: "Selatan", tags: ["AB"] },

        // Sehat/Unik (B+B)
        { name: "La Moringa", region: "Selatan", tags: ["BB"] },
        { name: "Burgreens Menteng", region: "Pusat", tags: ["BB"] },

        // Western Rooftop (C+A/C)
        { name: "Nustro Tebet Skyline", region: "Selatan", tags: ["CC", "CA"] },

        // Western Kasual (C+B)
        { name: "Zapoli Pizzeria", region: "Selatan", tags: ["CB"] },
        { name: "Nona Steak", region: "Barat", tags: ["CB"] },
        { name: "Dancing Goat Coffee", region: "Barat", tags: ["CB"] },

        // Street Food (D+D)
        { name: "Kuliner Jalan Sabang", region: "Pusat", tags: ["DD", "DA", "DB", "DC"] },
        { name: "Old Shanghai Sedayu City", region: "Timur", tags: ["DD", "DA", "DB", "DC"] },
        { name: "Hakuna Matata", region: "Timur", tags: ["DD", "DB"] }
    ];

    const allowedRegionsMap = {
        "Barat": ["Barat", "Pusat", "Selatan", "Timur"],
        "Timur": ["Timur", "Selatan", "Pusat"],
        "Pusat": ["Pusat", "Selatan"],
        "Selatan": ["Selatan", "Pusat"]
    };

    // --- Questions (Silent Mode - No [A] tags) ---
    const questions = [
        {
            id: 'q1',
            text: "Sore ini mood kamu lagi pengen ngapain?",
            options: [
                { label: "Jalan-jalan santai, cuci mata, lihat suasana sekitar", value: "A" },
                { label: "Duduk manis, deep talk, ngopi cantik", value: "B" },
                { label: "Hands-on! Berkreasi atau main aktivitas seru", value: "C" }
            ]
        },
        {
            id: 'q2',
            text: "Pengen latar belakang foto kita kayak gimana?",
            options: [
                { label: "Arsitektur lawas / Sejarah / Budaya", value: "A" },
                { label: "Taman asri / Bunga-bunga / Minimalis", value: "B" },
                { label: "Ruang seni / Wahana / Modern", value: "C" }
            ]
        },
        {
            id: 'q3',
            text: "Buat makan malam, perut lagi craving apa?",
            options: [
                { label: "Nusantara / Masakan Rumah / Otentik", value: "A" },
                { label: "Sehat / Organik / Unik", value: "B" },
                { label: "Western (Steak / Pizza / Pasta)", value: "C" },
                { label: "Street Food / Jajan Bebas", value: "D" }
            ]
        },
        {
            id: 'q4',
            text: "Suasana makan malam impian kamu hari ini:",
            options: [
                { label: "Homey / Klasik / Nostalgia", value: "A" },
                { label: "Taman rindang / Kafe kasual estetik", value: "B" },
                { label: "Rooftop / City Light", value: "C" },
                { label: "Ramah / Merakyat / Hidup", value: "D" }
            ]
        },
        {
            id: 'q5',
            text: "Terakhir, pilih skenario penutup malam yang paling nyaman:",
            options: [
                { label: "Jalan berdampingan di udara segar (Tebet Eco Park) 🌳", value: "Tebet Eco Park" },
                { label: "Duduk santai, ngemil dessert & nonton (Coffee & Thyme / Potluck) ☕", value: "Coffee & Thyme / Potluck" }
            ]
        }
    ];

    // --- State ---
    let currentStepIndex = 0;
    let answers = { q1: "", q2: "", q3: "", q4: "", q5: "" };

    // --- Interaction ---
    openBtn.addEventListener('click', () => {
        invitationCard.classList.add('hidden');
        surveyContainer.classList.remove('hidden');
        renderQuestion(currentStepIndex);
    });

    function fadeTransition(callback) {
        questionText.style.opacity = 0;
        optionsContainer.style.opacity = 0;
        setTimeout(() => {
            callback();
            questionText.style.opacity = 1;
            optionsContainer.style.opacity = 1;
        }, 300);
    }

    function renderQuestion(index) {
        if (index >= questions.length) {
            calculateAndFinish();
            return;
        }

        const q = questions[index];
        fadeTransition(() => {
            questionText.textContent = q.text;
            optionsContainer.innerHTML = '';

            q.options.forEach(opt => {
                const btn = document.createElement('button');
                btn.className = 'option-btn';
                btn.textContent = opt.label;
                btn.onclick = () => {
                    answers[q.id] = opt.value;
                    currentStepIndex++;
                    renderQuestion(currentStepIndex);
                };
                optionsContainer.appendChild(btn);
            });
        });
    }

    function pickRandom(arr) {
        return arr[Math.floor(Math.random() * arr.length)];
    }

    async function calculateAndFinish() {
        surveyContainer.classList.add('hidden');
        finalContainer.classList.remove('hidden');

        // --- Logic Engine ---

        // 1. Calculate Phase 1
        const tagP1 = answers.q1 + answers.q2;
        let p1Matches = phase1Spots.filter(s => s.tags.includes(tagP1));
        if (p1Matches.length === 0) p1Matches = phase1Spots.slice(0, 5); // Fallback
        const p1Choice = pickRandom(p1Matches); // Auto-select random match

        // 2. Calculate Phase 2
        const allowedRegions = allowedRegionsMap[p1Choice.region] || ["Selatan", "Pusat"];
        const tagP2 = answers.q3 + answers.q4;

        let p2Matches = phase2Spots.filter(s =>
            s.tags.includes(tagP2) && allowedRegions.includes(s.region)
        );

        if (p2Matches.length === 0) {
            // Soft fallback: relax tags, strict region
            p2Matches = phase2Spots.filter(s => allowedRegions.includes(s.region));
        }
        if (p2Matches.length === 0) {
            // Hard fallback: relax region
            p2Matches = phase2Spots.slice(0, 5);
        }
        const p2Choice = pickRandom(p2Matches);

        // 3. Phase 3 is direct
        const p3Choice = answers.q5;

        // --- Display & Save ---
        const deviceType = /Mobile|Android|iPhone/i.test(navigator.userAgent) ? 'Mobile' : 'Desktop';
        const timestamp = new Date().toLocaleString('id-ID'); // Current timestamp of filling

        // Google Calendar Link Generation
        // Targeted Date: Feb 14, 2026
        const eventTitle = encodeURIComponent("Valentine Date ❤️");
        const eventDetails = encodeURIComponent(
            `Itinerary:\n\n15:00 - 18:00: ${p1Choice.name}\n18:00 - 19:30: ${p2Choice.name}\n19:30 - Selesai: ${p3Choice}\n\nCan't wait! 💖`
        );
        const eventLocation = encodeURIComponent(p1Choice.name); // Start point
        // 2026-02-14 15:00 to 22:00 WIB (UTC+7) -> Subtract 7 hours for UTC format
        // 15:00 WIB = 08:00 UTC
        // 22:00 WIB = 15:00 UTC
        const dates = "20260214T080000Z/20260214T150000Z";

        const gcalUrl = `https://www.google.com/calendar/render?action=TEMPLATE&text=${eventTitle}&dates=${dates}&details=${eventDetails}&location=${eventLocation}`;

        finalSummary.innerHTML = `
            <div class="summary-list">
                <p><strong>15:00 - 18:00</strong><br>${p1Choice.name}</p>
                <p><strong>18:00 - 19:30</strong><br>${p2Choice.name}</p>
                <p><strong>19:30 - Selesai</strong><br>${p3Choice}</p>
                
                <a href="${gcalUrl}" target="_blank" class="glow-button" style="display:block; margin-top:20px; text-decoration:none; color:white; font-size:0.9rem;">
                    Add to Calendar 📅
                </a>
            </div>
        `;

        const resultPayload = {
            recipient: "Monica Theresa Ken Ratri Drupadi",
            plan: {
                afternoon: p1Choice.name,
                dinner: p2Choice.name,
                night: p3Choice,
                route: `${p1Choice.region} -> ${p2Choice.region}`
            },
            device: deviceType,
            timestamp: timestamp
        };

        const history = JSON.parse(localStorage.getItem('valentine_responses') || '[]');
        history.push(resultPayload);
        localStorage.setItem('valentine_responses', JSON.stringify(history));

        if (WEBHOOK_URL) {
            try {
                const feedbackMsg = document.createElement('p');
                feedbackMsg.className = "sending-msg";
                feedbackMsg.innerHTML = "<i>Meracik itinerary terbaik... 🪄</i>";
                finalContainer.querySelector('.final-card').appendChild(feedbackMsg);

                await fetch(WEBHOOK_URL, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({
                        content: `💌 **Itinerary Valentine!**\n**Device:** ${deviceType}\n\n**🕒 15:00 - 18:00:** ${resultPayload.plan.afternoon}\n**🕒 18:00 - 19:30:** ${resultPayload.plan.dinner}\n**🕒 19:30 - ...:** ${resultPayload.plan.night}\n**🚗 Rute:** ${resultPayload.plan.route}\n\n*${timestamp}*`
                    })
                });

                feedbackMsg.innerHTML = "<b>Itinerary Aman, lets have a lovely date. 💖</b>";
            } catch (err) {
                const feedbackMsg = finalContainer.querySelector('.sending-msg');
                if (feedbackMsg) feedbackMsg.innerHTML = "Tersimpan di HP. Screenshot ini ya! 💖";
            }
        }
    }
});
