document.addEventListener('DOMContentLoaded', () => {
    // Console log for verification
    console.log('PARfolio Landing Page Loaded');

    // Add scroll reveal animation here later
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('visible');
            }
        });
    });

    document.querySelectorAll('.feature-card').forEach((el) => {
        el.style.opacity = '0';
        el.style.transform = 'translateY(20px)';
        el.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
        observer.observe(el);
    });

    // Simple reveal handler
    window.addEventListener('scroll', () => {
        const triggers = document.querySelectorAll('.feature-card');
        triggers.forEach(trigger => {
            const top = trigger.getBoundingClientRect().top;
            if (top < window.innerHeight - 100) {
                trigger.style.opacity = '1';
                trigger.style.transform = 'translateY(0)';
            }
        });
    });
});
