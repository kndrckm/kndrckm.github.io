/** @type {import('tailwindcss').Config} */
module.exports = {
    content: [
        "./*.html",
        "./*.js"
    ],
    theme: {
        extend: {
            fontFamily: {
                sans: ['Inter', 'sans-serif']
            },
            colors: {
                primary: '#1D1D1F',
                secondary: '#6E6E73',
                accent: '#007AFF',
                'azure-light': '#F5F7FA',
            },
            boxShadow: {
                'ios-deep': '0 30px 60px -12px rgba(0,0,0,0.4)',
                'ios-card': '0 10px 40px rgba(0,0,0,0.03)',
                'soft-xl': '0 20px 40px -10px rgba(0,0,0,0.05)',
                'floating': '0 30px 60px -15px rgba(0,0,0,0.1)',
            },
            keyframes: {
                'mesh-float': {
                    '0%': { backgroundPosition: '0% 50%' },
                    '50%': { backgroundPosition: '100% 50%' },
                    '100%': { backgroundPosition: '0% 50%' },
                },
                'wiggle-vertical': {
                    '0%, 100%': { transform: 'translateY(-50%)' },
                    '25%': { transform: 'translateY(calc(-50% - 5px))' },
                    '75%': { transform: 'translateY(calc(-50% + 5px))' },
                },
                'pop-in': {
                    '0%': { opacity: '0', transform: 'scale(0.96) translateY(20px)' },
                    '100%': { opacity: '1', transform: 'scale(1) translateY(0)' },
                },
                'skeleton-shimmer': {
                    '0%': { backgroundPosition: '200% 0' },
                    '100%': { backgroundPosition: '-200% 0' },
                }
            },
            animation: {
                'mesh-float': 'mesh-float 15s ease infinite',
                'wiggle-scroll': 'wiggle-vertical 0.5s ease-in-out',
                'pop': 'pop-in 1.2s cubic-bezier(0.16, 1, 0.3, 1) forwards',
                'skeleton': 'skeleton-shimmer 1.5s infinite',
            }
        }
    },
    plugins: [],
}
