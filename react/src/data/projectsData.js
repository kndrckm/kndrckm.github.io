// Project Data for React Portfolio - Exact match to original
export const projectsData = [
    {
        slug: "kavling-12",
        title: "Kavling 12",
        location: "Batam, Indonesia",
        category: "Residential",
        year: "2025",
        area: "180 sq m",
        style: "Modern Tropical",
        image: "/assets/projects/kavling12_1.webp",
        nightImage: "/assets/projects/kavling12_2.webp",
        video: "/assets/kavling12.mp4",
        hasNightMode: true,
        gallery: [
            { src: "/assets/projects/kavling12_5.webp", span: "md:col-span-8" },
            { src: "/assets/projects/kavling12_3.webp", span: "md:col-span-4" },
            { src: "/assets/projects/kavling12_4.webp", span: "md:col-span-4", hasNight: true, nightSrc: "/assets/projects/kavling12_4b.webp" },
        ],
        galleryRow2: [
            "/assets/projects/kavling12_6.webp",
            "/assets/projects/kavling12_7.webp",
            "/assets/projects/kavling12_8.webp",
        ],
        description: "Kavling 12 is envisioned as a blank canvas—a structural framework that allows users the freedom to express themselves through material and color.",
        descriptionExtra: "Beyond its flexible aesthetic, the core strength of Kavling 12 lies in its performance. The massing is strategically carved to capture prevailing winds and filter natural sunlight deep into the living spaces.",
        descriptionExtra2: "This approach ensures that while the facade remains an adaptable canvas for the owner's taste, the comfort and energy efficiency of the home remain absolute and timeless.",
        quote: "A home designed to breathe and evolve with you.",
        features: [
            { icon: "wind", title: "Passive Design", subtitle: "Optimized Air & Light" }
        ]
    },
    {
        slug: "a-home",
        title: "A Home",
        location: "Bogor, Indonesia",
        category: "Residential",
        year: "2024",
        area: "130 sqm",
        style: "Modern Tropical",
        image: "/assets/projects/ahome_1.webp",
        heroImage: "/assets/projects/ahome_2.webp",
        video: "/assets/ahome.mp4",
        pano: "/assets/projects/ahome_pano.webp",
        hasNightMode: false,
        gallery: [
            { src: "/assets/projects/ahome_3.webp", span: "md:col-span-3" },
            { src: "/assets/projects/ahome_4.webp", span: "md:col-span-7" },
            { src: "/assets/projects/ahome_5.webp", span: "md:col-span-7" },
            { src: "/assets/projects/ahome_6.webp", span: "md:col-span-3" },
        ],
        description: "Designed to accommodate the project owner's elderly mother, this home prioritizes accessibility on the first floor while maintaining a seamless flow.",
        descriptionExtra: "The architecture invites natural windflow and sunlight to fill the interiors, anchored by a koi pond at the intersection of spaces and lush pot greeneries—creating a sanctuary for the wellbeing of the owner and their mother.",
        quote: "A sanctuary for wellbeing.",
        features: [
            { icon: "heart", title: "Wellbeing", subtitle: "Generational Harmony" }
        ]
    },
    {
        slug: "boarding-house",
        title: "Boarding House",
        location: "Yogyakarta, Indonesia",
        category: "Commercial",
        year: "2024",
        area: "250 sq m",
        style: "Industrial Modern",
        image: "https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?q=80&w=2600",
        hasNightMode: false,
        gallery: [],
        description: "A commercial boarding house optimized for natural ventilation and student living.",
        quote: "Community living, reimagined."
    },
    {
        slug: "private-villa",
        title: "Private Villa",
        location: "Bali, Indonesia",
        category: "Hospitality",
        year: "2025",
        area: "300 sq m",
        style: "Balinese Contemporary",
        image: "https://images.unsplash.com/photo-1600585154340-be6161a56a0c?q=80&w=2600",
        hasNightMode: false,
        gallery: [],
        description: "A private retreat blending traditional Balinese architecture with contemporary luxury.",
        quote: "Where tradition meets modernity."
    }
];

export const getProjectBySlug = (slug) => projectsData.find(p => p.slug === slug);
