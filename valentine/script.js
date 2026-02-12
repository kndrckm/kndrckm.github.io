document.addEventListener("DOMContentLoaded", () => {
    document.body.classList.add('loaded');

    // --- Floating Hearts Logic ---
    function createHeart() {
        const heart = document.createElement('div');
        heart.classList.add('floating-heart');
        heart.innerText = ['❤️', '💖', '🌸', '✨', '💕', '🌹'][Math.floor(Math.random() * 6)];

        heart.style.left = Math.random() * 100 + 'vw';
        heart.style.animationDuration = (Math.random() * 3 + 4) + 's';
        heart.style.fontSize = (Math.random() * 20 + 15) + 'px';

        document.body.appendChild(heart);
        setTimeout(() => heart.remove(), 7000);
    }
    setInterval(createHeart, 400);

    const openBtn = document.getElementById('open-btn');
    const invitationCard = document.getElementById('invitation-card');
    const surveyContainer = document.getElementById('survey-container');
    const finalContainer = document.getElementById('final-container');

    const questionText = document.getElementById('question-text');
    const optionsContainer = document.getElementById('options-container');
    const finalSummary = document.getElementById('final-summary');

    const WEBHOOK_URL = "https://discord.com/api/webhooks/1471375539360235560/CrxtjoFgI8YpSWFsYoPD_Mym_MVJnHH4p-CejRjte2w2PIIUwrEyBW0OBDaIH9JXvbMQ";

    // --- Data Structures (Enhanced) ---

    // Phase 1: Branching Data
    const phase1Data = {
        "A": {
            text: "Siap, mode santai! Suasana visual seperti apa yang paling memanggil jiwamu?",
            options: [
                {
                    label: "Nature & Floral: Piknik di rumput hijau / Toko bunga wangi",
                    target: {
                        name: "ONNI House",
                        region: "Barat",
                        mapUrl: "https://maps.app.goo.gl/2foxpKvhE2Pe4hCd7",
                        image: "https://manual.co.id/wp-content/uploads/2018/06/ONNI-Shop_Cafe_Tj-Duren-9-980x719.jpg" // Florist Cafe
                    }
                },
                {
                    label: "Kyoto Vibes: Ngopi teduh nuansa taman Jepang",
                    target: {
                        name: "Kyō Coffee",
                        region: "Timur",
                        mapUrl: "https://maps.app.goo.gl/eYK8WneKiRe95hoR8",
                        image: "https://manual.co.id/wp-content/uploads/2020/08/kyo_jatiwaringin-11-980x719.jpg" // Japanese Cafe
                    }
                },
                {
                    label: "Modern Minimalist: Ngopi & donat di kafe Jepang sleek",
                    target: {
                        name: "Saputto",
                        region: "Selatan",
                        mapUrl: "https://maps.app.goo.gl/tY2vBaFf7kk8agwd8",
                        image: "https://awsimages.detik.net.id/community/media/visual/2025/08/31/saputto-1756603003947.jpeg?w=700&q=90" // Minimalist Coffee
                    }
                },
                {
                    label: "Intellectual & Art: Perpus hening arsitektur keren",
                    target: {
                        name: "Perpustakaan Cikini",
                        region: "Pusat",
                        mapUrl: "https://maps.app.goo.gl/rpeZNUcwjhhJ2N329",
                        image: "https://ik.imagekit.io/tvlk/blog/2022/08/Perpustakaan-Jakarta-TIM-Cikini-Traveloka-Xperience-1.jpg" // Library
                    }
                },
                {
                    label: "Classy Showroom: Kafe elegan menyatu dengan showroom seni",
                    target: {
                        name: "Birubeeru",
                        region: "Pusat",
                        mapUrl: "https://maps.app.goo.gl/B65Ykny2PB3cuFwx9",
                        image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTeKwynGweOE3l8QjY7WnFWnHRhUtDuoQg85A&s" // Chic Cafe
                    }
                }
            ]
        },
        "B": {
            text: "Oke, mode aktif! Kegiatan apa yang bikin kamu penasaran?",
            options: [
                { label: "Dirty Hands: Main tanah liat & bikin keramik", target: { name: "Lost in Clay Jakarta", region: "Pusat", mapUrl: "https://maps.app.goo.gl/yu5rDsnteN72DFyLA", image: "https://www.socialexpat.net/wp-content/uploads/2024/05/Header-Web-1200x628-4-1024x536.jpg" } },
                { label: "Crafty Hands: Meronce manik-manik (beads) lucu", target: { name: "LIT House", region: "Selatan", mapUrl: "https://maps.app.goo.gl/irbZKHAMW5i7KdaY7", image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRMym_YmqyhfbyUmmXmw-a2g7RsgY1PlkvQsA&s" } },
                { label: "Focus Game: Uji ketangkasan lewat Panahan", target: { name: "Shoot Archery", region: "Selatan", mapUrl: "https://maps.app.goo.gl/71McHPu3YY2qi2Bu5", image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSGNTSMxrFjqIeYcysQx1pRYU41CgFW3X-lag&s" } },
                { label: "Furry Friends: Main sama kucing-kucing ras gemas", target: { name: "Kopi Cat Kemang", region: "Selatan", mapUrl: "https://maps.app.goo.gl/BaaakrC22ncTxF6Z9", image: "https://groovy.co.id/wp-content/uploads/2025/04/kopicat-img-home-kemang.jpg" } },
                { label: "High Altitude: Naik Bianglala lihat pemandangan kota", target: { name: "J-Sky Ferris Wheel", region: "Timur", mapUrl: "https://maps.app.goo.gl/7znsMqadcmn7Fz9w7", image: "https://res.klook.com/images/fl_lossy.progressive,q_65/c_fill,w_1295,h_863/w_80,x_15,y_15,g_south_west,l_Klook_water_br_trans_yhcmh3/activities/oq6ftynmnk0j7bzvljpj/TiketJ-SkyFerrisWheeldiJakarta.jpg" } },
                { label: "City Pop: Photobooth kekinian & jalan di mal legendaris", target: { name: "Sarinah", region: "Pusat", mapUrl: "https://maps.app.goo.gl/ErGxVk53x3EuCUE28", image: "https://awsimages.detik.net.id/visual/2024/09/28/gedung-sarinah-dok-sarinah_169.png?w=1200" } }
            ]
        },
        "C": {
            text: "Ayo berpetualang! Pemandangan apa yang mau dilihat?",
            options: [
                { label: "Oriental Vibes: Arsitektur Tionghoa & Lampion", target: { name: "Petak Enam", region: "Barat", mapUrl: "https://maps.app.goo.gl/G23J8pwHQURcnPLn6", image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQhlxaluZBXClI_HEXV3Amd-7fdrRGXI_2Svg&s" } },
                { label: "Bali Vibes: Suasana Pura hening dan otentik", target: { name: "Pura Aditya Jaya", region: "Timur", mapUrl: "https://maps.app.goo.gl/gKeN8rjga76jkSfB9", image: "https://manual.co.id/wp-content/uploads/2019/03/Manual-Excursion-Pura-Rawamangun-10-980x719.jpg" } },
                { label: "Colonial Vibes: Gedung tua bersejarah naik sepeda ontel", target: { name: "Kota Tua", region: "Pusat", mapUrl: "https://maps.app.goo.gl/MaxH1y8y6Q9uZbfH8", image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSYIMDVgBDorD6pss7tXyG85ekH4hR0P4OCGg&s" } },
                { label: "Lake Vibes: Jalan santai di pinggir danau asri", target: { name: "Setu Babakan", region: "Selatan", mapUrl: "https://maps.app.goo.gl/dxhCyDrGQkWByMSo6", image: "https://multimedia.beritajakarta.id/photo/2014_508c75c8507a2ae5223dfd2faeb98122/c33bc85c9509f62e2c9bd20b6152c344.jpg" } }
            ]
        }
    };

    // Phase 2: Matrix Table (Dinner)
    // Structure: {name, mapUrl, image}
    const phase2Matrix = {
        "U": { // Comfort
            "Barat": { name: "Uma Oma (Pusat)", mapUrl: "https://maps.app.goo.gl/zZwbB3bUSyMsqwh86", image: "https://images.bisnis.com/thumb/posts/2023/09/25/1698144/uma_oma_1695607963.jpg?w=450&h=237" },
            "Timur": { name: "Kopi Tenong (Timur)", mapUrl: "https://maps.app.goo.gl/rKjQeYoxkYmKy8jQ7", image: "https://lh3.googleusercontent.com/p/AF1QipM1gNyoHvnQfNgYs6NXF_FK-pTKqlBM8AJmtLMZ=s1600-h380" },
            "Pusat": { name: "Uma Oma (Pusat)", mapUrl: "https://maps.app.goo.gl/zZwbB3bUSyMsqwh86", image: "https://images.bisnis.com/thumb/posts/2023/09/25/1698144/uma_oma_1695607963.jpg?w=450&h=237" },
            "Selatan": { name: "Tuniang Bali (Selatan)", mapUrl: "https://maps.app.goo.gl/XXS8k4Nt1jRSepFg8", image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ2DwZVx-C1z3huXxDBK4iPIjk3RfbsL8xe4Q&s" }
        },
        "V": { // Western
            "Barat": { name: "Nona Steak (Barat)", mapUrl: "https://maps.app.goo.gl/T4pnMksYexh5BhKbA", image: "https://static.promediateknologi.id/crop/0x0:0x0/1200x600/webp/photo/p1/294/2025/03/24/Steak-picanha-Nona-Steak-146279687.jpg" },
            "Timur": { name: "Zapoli (Selatan)", mapUrl: "https://maps.app.goo.gl/zm3Lm42rnowGN2zf9", image: "https://manual.co.id/wp-content/uploads/2022/07/zapoli_kemang_utara_web-7-980x719.jpg" },
            "Pusat": { name: "Zapoli (Selatan)", mapUrl: "https://maps.app.goo.gl/zm3Lm42rnowGN2zf9", image: "https://manual.co.id/wp-content/uploads/2022/07/zapoli_kemang_utara_web-7-980x719.jpg" },
            "Selatan": { name: "Zapoli (Selatan)", mapUrl: "https://maps.app.goo.gl/zm3Lm42rnowGN2zf9", image: "https://manual.co.id/wp-content/uploads/2022/07/zapoli_kemang_utara_web-7-980x719.jpg" }
        },
        "W": { // Rooftop
            "Barat": { name: "Nustro (Selatan)", mapUrl: "https://maps.app.goo.gl/6mbjLSq3epHXSNkZ8", image: "https://awsimages.detik.net.id/community/media/visual/2025/01/30/nustro-tebet-skyline-3_43.jpeg?w=600&q=90" },
            "Timur": { name: "Nustro (Selatan)", mapUrl: "https://maps.app.goo.gl/6mbjLSq3epHXSNkZ8", image: "https://awsimages.detik.net.id/community/media/visual/2025/01/30/nustro-tebet-skyline-3_43.jpeg?w=600&q=90" },
            "Pusat": { name: "Nustro (Selatan)", mapUrl: "https://maps.app.goo.gl/6mbjLSq3epHXSNkZ8", image: "https://awsimages.detik.net.id/community/media/visual/2025/01/30/nustro-tebet-skyline-3_43.jpeg?w=600&q=90" },
            "Selatan": { name: "Nustro (Selatan)", mapUrl: "https://maps.app.goo.gl/6mbjLSq3epHXSNkZ8", image: "https://awsimages.detik.net.id/community/media/visual/2025/01/30/nustro-tebet-skyline-3_43.jpeg?w=600&q=90" }
        },
        "X": { // Unique
            "Barat": { name: "Dancing Goat (Barat)", mapUrl: "https://maps.app.goo.gl/QBm68nSR3tUBu4mt5", image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSQrDHy218C4zcCTqkogF8K-23a1QjbojGZ1g&s" },
            "Timur": { name: "Hakuna Matata (Timur)", mapUrl: "https://maps.app.goo.gl/HJmRxiJ8RmGVJ2J98", image: "https://hypeabis.id/assets/content/2021051414235200000020210206154228.jpg" },
            "Pusat": { name: "Birubeeru (Pusat)", mapUrl: "https://maps.app.goo.gl/B65Ykny2PB3cuFwx9", image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTeKwynGweOE3l8QjY7WnFWnHRhUtDuoQg85A&s" },
            "Selatan": { name: "Mandira's (Selatan)", mapUrl: "https://maps.app.goo.gl/iFTqn6tXMdVrEcKo8", image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRKkLUXc_vr_YKpAY9eiwcNiEJqqAAGR9USDw&s" }
        },
        "Y": { // Festive
            "Barat": { name: "Petak Enam (Barat)", mapUrl: "https://maps.app.goo.gl/G23J8pwHQURcnPLn6", image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQhlxaluZBXClI_HEXV3Amd-7fdrRGXI_2Svg&s" },
            "Timur": { name: "Old Shanghai (Timur)", mapUrl: "https://maps.app.goo.gl/11pVwm7ffqzhEoGo9", image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS9PDskwH61ghs4Vyy4jELfPlkTianITufGpg&s" },
            "Pusat": { name: "Jalan Sabang (Pusat)", mapUrl: "https://maps.app.goo.gl/vcmnV8FRsLzrMDrd8", image: "https://www.pinhome.id/info-area/wp-content/uploads/2023/03/190509122358-772.webp" },
            "Selatan": { name: "Jalan Sabang (Pusat)", mapUrl: "https://maps.app.goo.gl/vcmnV8FRsLzrMDrd8", image: "https://www.pinhome.id/info-area/wp-content/uploads/2023/03/190509122358-772.webp" }
        },
        "Z": { // Healthy
            "Barat": { name: "Burgreens (Pusat)", mapUrl: "https://maps.app.goo.gl/yhJkJwwgUn2Fa45H8", image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTKtLoUXOwFmu-lmRn_9IDWquEKn69nFJXm0A&s" },
            "Timur": { name: "Burgreens (Pusat)", mapUrl: "https://maps.app.goo.gl/yhJkJwwgUn2Fa45H8", image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTKtLoUXOwFmu-lmRn_9IDWquEKn69nFJXm0A&s" },
            "Pusat": { name: "Burgreens (Pusat)", mapUrl: "https://maps.app.goo.gl/yhJkJwwgUn2Fa45H8", image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTKtLoUXOwFmu-lmRn_9IDWquEKn69nFJXm0A&s" },
            "Selatan": { name: "La Moringa (Selatan)", mapUrl: "https://maps.app.goo.gl/NFA9hjrzRxfgG7NAA", image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTqGtnsCmY9Rl4ZVAisTtJv5tLrqUvxwsfZtQ&s" }
        }
    };

    // Phase 3: Finale (Fixed Data)
    const phase3Data = {
        "Tebet Eco Park": { name: "Tebet Eco Park", mapUrl: "https://maps.app.goo.gl/aParLwTZzsTFrfgk8", image: "https://asset.kompas.com/crops/8_GFpm-eSvQ0Ym5gtXUXbhExB74=/8x0:683x450/1200x800/data/photo/2022/02/08/62022fea9a150.jpeg" },
        "Coffee & Thyme / Potluck": { name: "Coffee & Thyme / Potluck", mapUrl: "https://maps.app.goo.gl/oUeBszW3L3EescZu6", image: "https://manual.co.id/wp-content/uploads/2023/02/34_potluck-980x719.jpg" }
    };

    // --- State ---
    const q1Options = [
        { label: "Chill & Aesthetic: Mode 'Putri', duduk cantik, foto visual tenang", value: "A" },
        { label: "Creative & Playful: Gerak, bikin sesuatu, main game, interaksi seru", value: "B" },
        { label: "Explore & Culture: Jalan kaki santai, pemandangan baru, wisata budaya", value: "C" }
    ];

    const q3Options = [
        { label: "Comfort Nusantara: Masakan Rumahan/Tradisional bumbu menyaman", value: "U" },
        { label: "Western Meat/Pizza: Daging (Steak) atau Pizza Italia", value: "V" },
        { label: "Rooftop City Light: Pemandangan lampu kota dari atas", value: "W" },
        { label: "Unique Ambience: Tempat unik/tematik (Vintage/Garden/Boho)", value: "X" },
        { label: "Festive / Street Food: Wisata kuliner jajan santai / ramai", value: "Y" },
        { label: "Healthy & Light: Makan bersih (clean eating), sayur/plant-based", value: "Z" }
    ];

    let currentStep = 0;
    let answers = { q1: "", p1Spot: null, q3: "", finalSpot: null }; // finalSpot is now object

    // --- Helper Logic ---
    function formatLabel(text) {
        // "Label: Desc" -> "<strong>Label:</strong> Desc"
        if (text.includes(":")) {
            const parts = text.split(":");
            return `<strong>${parts[0]}:</strong>${parts.slice(1).join(":")}`;
        }
        return text;
    }

    function getNextQuestion() {
        if (currentStep === 0) {
            return {
                text: "Pertama-tama... Sabtu ini energi kamu lagi condong ke mana?",
                options: q1Options,
                onAnswer: (val) => {
                    answers.q1 = val;
                    currentStep = 1;
                }
            };
        } else if (currentStep === 1) {
            const data = phase1Data[answers.q1];
            return {
                text: data.text,
                options: data.options.map(opt => ({
                    label: opt.label,
                    value: opt.target
                })),
                onAnswer: (val) => {
                    answers.p1Spot = val;
                    currentStep = 2;
                }
            };
        } else if (currentStep === 2) {
            return {
                text: "Nah kalau buat makan, lagi pengen makanan yang gimana?",
                options: q3Options,
                onAnswer: (val) => {
                    answers.q3 = val;
                    currentStep = 3;
                }
            };
        } else if (currentStep === 3) {
            return {
                text: "Pilih skenario penutup malam yang paling nyaman:",
                options: [
                    { label: "Jalan berdampingan di udara segar", value: "Tebet Eco Park" },
                    { label: "Duduk santai, ngemil dessert, foto foto", value: "Coffee & Thyme / Potluck" }
                ],
                onAnswer: (val) => {
                    answers.finalSpot = phase3Data[val]; // Store full object
                    currentStep = 4;
                }
            };
        }
        return null;
    }

    // --- Interaction ---
    openBtn.addEventListener('click', () => {
        invitationCard.classList.add('hidden');
        surveyContainer.classList.remove('hidden');
        renderCurrentStep();
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

    function renderCurrentStep() {
        const q = getNextQuestion();
        if (!q) {
            calculateAndFinish();
            return;
        }

        fadeTransition(() => {
            questionText.textContent = q.text;
            optionsContainer.innerHTML = '';

            q.options.forEach(opt => {
                const btn = document.createElement('button');
                btn.className = 'option-btn';
                btn.innerHTML = formatLabel(opt.label); // Render HTML
                btn.onclick = () => {
                    q.onAnswer(opt.value);
                    renderCurrentStep();
                };
                optionsContainer.appendChild(btn);
            });
        });
    }

    async function calculateAndFinish() {
        surveyContainer.classList.add('hidden');
        finalContainer.classList.remove('hidden');

        // Logic Engine
        const region = answers.p1Spot.region;
        const q3Code = answers.q3;

        let dinnerSpot = phase2Matrix[q3Code][region];
        if (!dinnerSpot) dinnerSpot = { name: "Surprise Dinner Spot", mapUrl: "#", image: "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=400&q=80" };

        let deviceInfo = "Unknown Device";
        let locationInfo = "Unknown Location";
        const ua = navigator.userAgent;

        if (/android/i.test(ua)) {
            deviceInfo = "Android";
            if (ua.includes("; ")) deviceInfo += " (Mobile)";
        } else if (/iPad|iPhone|iPod/.test(ua)) {
            deviceInfo = "iOS Device";
        } else if (/Windows/.test(ua)) deviceInfo = "Windows PC";

        try {
            const ipRes = await fetch('https://ipapi.co/json/');
            if (ipRes.ok) {
                const ipData = await ipRes.json();
                locationInfo = `${ipData.city}, ${ipData.region}`;
            }
        } catch (e) { console.log("Silent location check failed"); }

        const timestamp = new Date().toLocaleString('id-ID');

        // Retrieve User Choices for Logging
        const choice1 = q1Options.find(o => o.value === answers.q1)?.label || answers.q1;
        // Find Q2 label by comparing target reference. 
        // Note: answers.p1Spot is the target object.
        const choice2 = phase1Data[answers.q1].options.find(o => o.target === answers.p1Spot)?.label || answers.p1Spot.name;
        const choice3 = q3Options.find(o => o.value === answers.q3)?.label || answers.q3;
        const choice4 = answers.finalSpot.name;

        // Google Calendar Link
        const eventTitle = encodeURIComponent("Valentine Date ❤️");
        const eventDetails = encodeURIComponent(
            `Itinerary:\n15:00: ${answers.p1Spot.name}\n18:00: ${dinnerSpot.name}\n19:30: ${answers.finalSpot.name}`
        );
        const dates = "20260214T080000Z/20260214T150000Z";
        const gcalUrl = `https://www.google.com/calendar/render?action=TEMPLATE&text=${eventTitle}&dates=${dates}&details=${eventDetails}`;

        // Helper for summary item (Compact Left-Right Layout)
        const createSummaryItem = (time, spot, isFirst = false) => `
            <div style="margin-bottom: 25px; position: relative;">
                
                <!-- Image Section -->
                <a href="${spot.mapUrl}" target="_blank" style="display: block; position: relative; text-decoration: none;">
                    <img src="${spot.image}" style="width: 100%; height: 120px; object-fit: cover; border-radius: 8px; margin-bottom: 15px; box-shadow: 0 4px 12px rgba(0,0,0,0.15);">
                    ${isFirst ? '<div style="position: absolute; top: 10px; right: 10px; background: white; color: #8a3b3b; padding: 4px 10px; border-radius: 20px; font-size: 0.75rem; font-weight: bold; box-shadow: 0 2px 5px rgba(0,0,0,0.2); animation: floatBadge 2s infinite ease-in-out;">Click Me! 👆</div>' : ''}
                </a>

                <!-- Content Row (Left: Name, Right: Time) -->
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px; padding: 0 5px;">
                    <a href="${spot.mapUrl}" target="_blank" style="font-size: 1.1rem; color: #8a3b3b; text-decoration: none; font-weight: 700; text-align: left;">
                        ${spot.name} 📍
                    </a>
                    <p style="margin: 0; font-size: 0.85rem; color: #666; font-weight: 600; text-align: right; white-space: nowrap;">
                        ${time}
                    </p>
                </div>

                <!-- Divider -->
                <div style="width: 100%; height: 1px; background: #eee; margin-top: 5px;"></div>
            </div>
        `;

        finalSummary.innerHTML = `
            <style>
                @keyframes floatBadge {
                    0%, 100% { transform: translateY(0); }
                    50% { transform: translateY(-5px); }
                }
            </style>
            <div class="summary-list" style="margin-top: 25px;">
                ${createSummaryItem("15:00 - 18:00", answers.p1Spot, true)}
                ${createSummaryItem("18:00 - 19:30", dinnerSpot)}
                ${createSummaryItem("19:30 - Selesai", answers.finalSpot)}
                
                <a href="${gcalUrl}" target="_blank" class="glow-button" style="display:block; margin-top:35px; text-decoration:none; color:white; font-size:0.9rem;">
                    Add to Calendar 📅
                </a>
            </div>
        `;

        const resultPayload = {
            recipient: "Monica Theresa Ken Ratri Drupadi",
            choices: {
                q1: choice1,
                q2: choice2,
                q3: choice3,
                q4: choice4
            },
            plan: {
                afternoon: answers.p1Spot.name,
                dinner: dinnerSpot.name,
                night: answers.finalSpot.name,
                route: `${answers.p1Spot.region} -> ${dinnerSpot.name}`
            },
            device: deviceInfo,
            location: locationInfo,
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
                        content: `💌 **Itinerary Valentine!**
**Device:** ${deviceInfo}
**Loc:** ${locationInfo}

**📋 Pilihan User:**
1. **Mood:** ${choice1}
2. **Activity:** ${choice2}
3. **Cravings:** ${choice3}
4. **Closing:** ${choice4}

**✨ The Result:**
**🕒 15:00:** ${resultPayload.plan.afternoon}
**🕒 18:00:** ${resultPayload.plan.dinner}
**🕒 19:30:** ${resultPayload.plan.night}
**🚗 Region:** ${resultPayload.plan.route}

*${timestamp}*`
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
