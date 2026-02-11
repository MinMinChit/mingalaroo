import './styles.css';
import { createClient } from '@supabase/supabase-js';

const SUPABASE_URL = 'https://aexphrsxtzpiltwjhcdt.supabase.co';
const SUPABASE_KEY = 'sb_publishable_1nIgoLuQc7H7Y2KyNZYByA_0SLziKHE';

const prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

const clamp = (value, min = 0, max = 1) => Math.min(max, Math.max(min, value));

const cubicBezier = (p1x, p1y, p2x, p2y) => {
  const cx = 3 * p1x;
  const bx = 3 * (p2x - p1x) - cx;
  const ax = 1 - cx - bx;
  const cy = 3 * p1y;
  const by = 3 * (p2y - p1y) - cy;
  const ay = 1 - cy - by;

  const sampleCurveX = (t) => ((ax * t + bx) * t + cx) * t;
  const sampleCurveY = (t) => ((ay * t + by) * t + cy) * t;
  const sampleCurveDerivativeX = (t) => (3 * ax * t + 2 * bx) * t + cx;

  const solveCurveX = (x) => {
    let t = x;
    for (let i = 0; i < 8; i += 1) {
      const x2 = sampleCurveX(t) - x;
      if (Math.abs(x2) < 1e-6) return t;
      const d2 = sampleCurveDerivativeX(t);
      if (Math.abs(d2) < 1e-6) break;
      t -= x2 / d2;
    }
    let t0 = 0;
    let t1 = 1;
    t = x;
    while (t0 < t1) {
      const x2 = sampleCurveX(t);
      if (Math.abs(x2 - x) < 1e-6) return t;
      if (x > x2) t0 = t;
      else t1 = t;
      t = (t1 + t0) / 2;
    }
    return t;
  };

  return (x) => sampleCurveY(solveCurveX(x));
};

const easeIn = cubicBezier(0.42, 0, 1, 1);
const easeInOutCubic = (t) => (t < 0.5 ? 4 * t * t * t : 1 - Math.pow(-2 * t + 2, 3) / 2);

const setupEmojiCursor = () => {
  const cursor = document.getElementById('emoji-cursor');
  if (!cursor) return;

  const onMove = (event) => {
    cursor.style.left = `${event.clientX}px`;
    cursor.style.top = `${event.clientY}px`;
    cursor.style.opacity = '1';
  };

  document.addEventListener('mousemove', onMove);
  document.addEventListener('mouseleave', () => {
    cursor.style.opacity = '0';
  });
};

const setupCurtain = () => {
  const curtain = document.getElementById('curtain');
  if (!curtain) return;

  const leftSvg = curtain.querySelector('.curtain-left .curtain-svg');
  const rightSvg = curtain.querySelector('.curtain-right .curtain-svg');
  const leftPath = curtain.querySelector('.curtain-left .curtain-path');
  const rightPath = curtain.querySelector('.curtain-right .curtain-path');
  const leftEdge = curtain.querySelector('.curtain-left .curtain-edge');
  const rightEdge = curtain.querySelector('.curtain-right .curtain-edge');

  let curtainWidth = 0;
  let curtainHeight = 0;
  let progress = 0;
  let animating = false;
  let opened = false;

  const updateViewBox = () => {
    curtainWidth = window.innerWidth / 2;
    curtainHeight = window.innerHeight;
    [leftSvg, rightSvg].forEach((svg) => {
      svg.setAttribute('viewBox', `0 0 ${curtainWidth} ${curtainHeight}`);
    });
    updatePaths(progress);
  };

  const getCurtainPath = (isLeft, p) => {
    const bottomOpenValue = easeIn(clamp((p - 0) / 0.8));
    const topOpenValue = easeIn(clamp((p - 0.4) / 0.6));
    const w = curtainWidth;
    const h = curtainHeight;

    if (isLeft) {
      const currentRightEdgeTop = w - w * topOpenValue;
      const currentRightEdgeBottom = w - w * bottomOpenValue * 1.5;
      return `M0 0 L${currentRightEdgeTop} 0 Q${currentRightEdgeTop} ${h * 0.6} ${currentRightEdgeBottom} ${h} L0 ${h} Z`;
    }

    const currentLeftEdgeTop = w * topOpenValue;
    const currentLeftEdgeBottom = w * bottomOpenValue * 1.5;
    return `M${w} 0 L${currentLeftEdgeTop} 0 Q${currentLeftEdgeTop} ${h * 0.6} ${currentLeftEdgeBottom} ${h} L${w} ${h} Z`;
  };

  const updatePaths = (p) => {
    if (!leftPath || !rightPath || !leftEdge || !rightEdge) return;
    const leftD = getCurtainPath(true, p);
    const rightD = getCurtainPath(false, p);
    leftPath.setAttribute('d', leftD);
    rightPath.setAttribute('d', rightD);
    leftEdge.setAttribute('d', leftD);
    rightEdge.setAttribute('d', rightD);
  };

  const openCurtain = () => {
    if (animating || opened || prefersReducedMotion) {
      finishOpen();
      return;
    }
    animating = true;
    const duration = 2500;
    const start = performance.now();

    const step = (now) => {
      const t = clamp((now - start) / duration);
      progress = easeInOutCubic(t);
      updatePaths(progress);
      if (t < 1) {
        requestAnimationFrame(step);
      } else {
        finishOpen();
      }
    };

    requestAnimationFrame(step);
  };

  const finishOpen = () => {
    opened = true;
    animating = false;
    updatePaths(1);
    curtain.classList.add('curtain-hidden');
    document.body.classList.add('page-ready');
    document.body.classList.remove('no-scroll');
    window.dispatchEvent(new Event('scroll'));
    setTimeout(() => curtain.remove(), 700);
  };

  curtain.addEventListener('click', openCurtain);
  curtain.addEventListener('keydown', (event) => {
    if (event.key === 'Enter' || event.key === ' ') {
      event.preventDefault();
      openCurtain();
    }
  });
  window.addEventListener('resize', updateViewBox);
  updateViewBox();
};

const setupParallax = () => {
  const heroBg = document.querySelector('.hero-bg');
  const heroCoupleWrap = document.querySelector('.hero-couple-wrap');
  if (!heroBg || !heroCoupleWrap) return;

  let ticking = false;
  const onScroll = () => {
    if (ticking) return;
    ticking = true;
    requestAnimationFrame(() => {
      if (!document.body.classList.contains('page-ready')) {
        ticking = false;
        return;
      }
      const scrollOffset = window.scrollY;
      const t = clamp(scrollOffset / 300);
      const bgScale = 1.4 - 0.25 * t;
      const coupleScale = 1.1 + 0.2 * t;
      heroBg.style.transform = `scale(${bgScale})`;
      heroCoupleWrap.style.transform = `translateX(-50%) scale(${coupleScale})`;
      ticking = false;
    });
  };

  window.addEventListener('scroll', onScroll, { passive: true });
  onScroll();
};

const setupRevealObserver = () => {
  const revealTargets = document.querySelectorAll('.reveal');
  const groupTargets = document.querySelectorAll('[data-observe]');

  const revealObserver = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (!entry.isIntersecting) return;
        entry.target.classList.add('is-visible');
        revealObserver.unobserve(entry.target);
      });
    },
    { threshold: 0.3 },
  );

  revealTargets.forEach((el) => revealObserver.observe(el));

  const groupObserver = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (!entry.isIntersecting) return;
        entry.target.classList.add('is-visible');
        entry.target.querySelectorAll('.reveal').forEach((child) => child.classList.add('is-visible'));
        groupObserver.unobserve(entry.target);
      });
    },
    { threshold: 0.3 },
  );

  groupTargets.forEach((el) => groupObserver.observe(el));
};

const setupTypewriter = () => {
  const typewriter = document.querySelector('[data-typewriter]');
  if (!typewriter) return;
  const text = typewriter.dataset.typewriter || '';
  let started = false;

  const observer = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (!entry.isIntersecting || started) return;
        started = true;
        const duration = 4000;
        const start = performance.now();

        const tick = (now) => {
          const t = clamp((now - start) / duration);
          const count = Math.floor(t * text.length);
          typewriter.textContent = text.slice(0, count);
          if (t < 1) requestAnimationFrame(tick);
        };

        requestAnimationFrame(tick);
      });
    },
    { threshold: 0.5 },
  );

  observer.observe(typewriter);
};

const setupSpouseTilt = () => {
  const heart = document.querySelector('.heart-tilt');
  const section = document.getElementById('spouse');
  if (!heart || !section) return;

  section.addEventListener('mousemove', (event) => {
    const rect = section.getBoundingClientRect();
    const centerX = rect.width / 2;
    const centerY = 400;
    const dx = event.clientX - rect.left - centerX;
    const dy = event.clientY - rect.top - centerY;
    const maxTilt = 0.5;
    const rotateX = -dy * 0.001 * maxTilt;
    const rotateY = dx * 0.001 * maxTilt;
    heart.style.transform = `perspective(600px) rotateX(${rotateX}rad) rotateY(${rotateY}rad)`;

    const gloss = heart.querySelector('.heart-gloss');
    if (gloss) {
      const reflectX = clamp((event.clientX - rect.left) / rect.width) * 2 - 1;
      const reflectY = clamp((event.clientY - rect.top) / rect.height) * 2 - 1;
      gloss.style.background = `radial-gradient(circle at ${50 - reflectX * 30}% ${50 - reflectY * 30}%, rgba(255,255,255,0.5), transparent 70%)`;
    }
  });
};

const setupPayment = () => {
  const options = document.querySelectorAll('.payment-option');
  const qrImage = document.getElementById('payment-qr');
  if (!options.length || !qrImage) return;

  options.forEach((option) => {
    option.addEventListener('click', () => {
      options.forEach((btn) => btn.classList.remove('is-active'));
      option.classList.add('is-active');
      const qr = option.dataset.qr;
      if (!qr) return;
      qrImage.classList.add('is-switching');
      setTimeout(() => {
        qrImage.src = qr;
        qrImage.classList.remove('is-switching');
      }, 200);
    });
  });
};

const setupModal = () => {
  const qrImage = document.getElementById('payment-qr');
  const modal = document.getElementById('qr-modal');
  const modalImage = document.getElementById('qr-modal-image');
  const closeBtn = document.querySelector('.qr-modal-close');
  if (!qrImage || !modal || !modalImage || !closeBtn) return;

  const closeModal = () => {
    modal.classList.remove('show');
    modal.setAttribute('aria-hidden', 'true');
  };

  qrImage.addEventListener('click', () => {
    modalImage.src = qrImage.src;
    modal.classList.add('show');
    modal.setAttribute('aria-hidden', 'false');
  });

  closeBtn.addEventListener('click', closeModal);
  modal.addEventListener('click', (event) => {
    if (event.target === modal) closeModal();
  });
};

const setupToast = () => {
  const toast = document.getElementById('toast');
  if (!toast) return () => {};

  let timeoutId = null;
  return (message) => {
    toast.textContent = message;
    toast.classList.add('show');
    clearTimeout(timeoutId);
    timeoutId = setTimeout(() => {
      toast.classList.remove('show');
    }, 2000);
  };
};

const setupCelebration = () => {
  const canvas = document.getElementById('celebration-canvas');
  if (prefersReducedMotion) return () => {};
  if (!canvas) return () => {};
  const ctx = canvas.getContext('2d');
  if (!ctx) return () => {};

  const particles = [];
  const confettiColors = ['#ff4d4d', '#4d79ff', '#4dff88', '#ffb84d', '#b44dff', '#ff4dd2', '#4de1ff', '#ffe44d'];
  const flowerEmojis = ['🌸', '🌺', '🌻', '🌹', '🌷', '🌼', '💐'];

  const resize = () => {
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;
  };

  window.addEventListener('resize', resize);
  resize();

  const draw = () => {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    let active = false;
    particles.forEach((p) => {
      p.update();
      p.draw(ctx);
      if (!p.done) active = true;
    });
    for (let i = particles.length - 1; i >= 0; i -= 1) {
      if (particles[i].done) particles.splice(i, 1);
    }
    if (active) requestAnimationFrame(draw);
  };

  const spawn = (x, y) => {
    const confettiCount = 200;
    const flowerCount = 30;

    for (let i = 0; i < confettiCount; i += 1) {
      const angle = Math.random() * Math.PI * 2;
      const speed = Math.random() * 15 + 7;
      particles.push(new ConfettiParticle({
        x,
        y,
        vx: Math.cos(angle) * speed,
        vy: Math.sin(angle) * speed,
        gravity: Math.random() * 0.2 + 0.1,
        drag: Math.random() * 0.05 + 0.93,
        size: Math.random() * 4 + 4,
        color: confettiColors[Math.floor(Math.random() * confettiColors.length)],
      }));
    }

    for (let i = 0; i < flowerCount; i += 1) {
      particles.push(new FlowerParticle({
        x: Math.random() * canvas.width,
        y: -Math.random() * 200 - 50,
        vy: Math.random() * 5 + 5,
        oscillationSpeed: Math.random() * 0.02 + 0.01,
        rotationSpeed: (Math.random() - 0.5) * 0.05,
        emoji: flowerEmojis[Math.floor(Math.random() * flowerEmojis.length)],
        pulsePhase: Math.random() * Math.PI * 2,
      }));
    }

    requestAnimationFrame(draw);
  };

  class ConfettiParticle {
    constructor({ x, y, vx, vy, gravity, drag, size, color }) {
      this.x = x;
      this.y = y;
      this.vx = vx;
      this.vy = vy;
      this.gravity = gravity;
      this.drag = drag;
      this.size = size;
      this.color = color;
      this.opacity = 1;
      this.done = false;
    }

    update() {
      this.x += this.vx;
      this.y += this.vy;
      this.vy += this.gravity;
      this.vx *= this.drag;
      this.opacity -= 0.002;
      if (this.opacity <= 0) this.done = true;
    }

    draw(context) {
      if (this.opacity <= 0) return;
      context.fillStyle = this.color;
      context.globalAlpha = this.opacity;
      context.beginPath();
      context.arc(this.x, this.y, this.size, 0, Math.PI * 2);
      context.fill();
      context.globalAlpha = 1;
    }
  }

  class FlowerParticle {
    constructor({ x, y, vy, oscillationSpeed, rotationSpeed, emoji, pulsePhase }) {
      this.x = x;
      this.y = y;
      this.vy = vy;
      this.oscillationSpeed = oscillationSpeed;
      this.rotationSpeed = rotationSpeed;
      this.emoji = emoji;
      this.time = 0;
      this.rotation = 0;
      this.pulsePhase = pulsePhase;
      this.done = false;
    }

    update() {
      if (this.vy > 2) {
        this.vy *= 0.92;
      } else {
        this.vy += 0.005;
      }
      this.y += this.vy;
      this.time += this.oscillationSpeed;
      this.rotation += this.rotationSpeed;
      this.x += Math.sin(this.time) * 2;
      if (this.y > window.innerHeight + 200) this.done = true;
    }

    draw(context) {
      context.save();
      context.translate(this.x, this.y);
      context.rotate(this.rotation);
      const scale = 1 + Math.sin(this.time * 2 + this.pulsePhase) * 0.1;
      context.scale(scale, scale);
      context.font = '38px serif';
      context.textAlign = 'center';
      context.textBaseline = 'middle';
      context.fillText(this.emoji, 0, 0);
      context.restore();
    }
  }

  return spawn;
};

const setupRSVP = () => {
  const nameEl = document.querySelector('[data-guest-name]');
  const attendingButton = document.querySelector('[data-rsvp="attending"]');
  const declineButton = document.querySelector('[data-rsvp="not_attending"]');
  const buttons = [attendingButton, declineButton].filter(Boolean);
  if (!nameEl || !buttons.length) return;

  const toast = setupToast();
  const celebrate = setupCelebration();
  const supabase = createClient(SUPABASE_URL, SUPABASE_KEY);

  const urlData = (() => {
    const path = window.location.pathname.replace(/^\/+|\/+$/g, '');
    const weddingId = path ? path.split('/')[0] : null;
    const params = new URLSearchParams(window.location.search);
    if (!params.toString()) {
      return { weddingId, invitedUserName: null, originalName: null };
    }
    const raw = params.get('guest') || 'Guest';
    const decoded = decodeURIComponent(raw.replace(/\+/g, ' '));
    const displayName = decoded
      .replace(/-/g, ' ')
      .split(' ')
      .filter(Boolean)
      .map((word) => word[0].toUpperCase() + word.slice(1).toLowerCase())
      .join(' ');
    const originalName = decoded
      .replace(/-/g, ' ')
      .split(' ')
      .filter(Boolean)
      .map((word) => (word ? word[0] + word.slice(1).toLowerCase() : word))
      .join(' ');
    return { weddingId, invitedUserName: displayName, originalName };
  })();

  if (urlData.invitedUserName) {
    nameEl.textContent = `Dear ${urlData.invitedUserName},`;
  }

  let isSubmitting = false;
  let cooldown = false;

  const updateRSVP = async (attendanceState) => {
    if (!urlData.originalName) {
      toast('Missing required information. Please check the URL.');
      return false;
    }

    if (isSubmitting) return false;
    isSubmitting = true;
    buttons.forEach((btn) => (btn.disabled = true));

    try {
      const { error } = await supabase
        .from('invited_users')
        .update({ attendance_state: attendanceState, guest_count: '0' })
        .eq('guest_name', decodeURIComponent(urlData.originalName.replace(/\+/g, ' ')));
      if (error) throw error;
      return true;
    } catch (error) {
      console.error('Failed to update RSVP', error);
      return false;
    } finally {
      isSubmitting = false;
      if (attendingButton) attendingButton.disabled = !urlData.originalName;
      if (declineButton) declineButton.disabled = false;
    }
  };

  if (attendingButton && !urlData.originalName) {
    attendingButton.disabled = true;
  }
  buttons.forEach((button) => {
    const action = button.dataset.rsvp;

    button.addEventListener('click', async () => {
      if (action === 'attending') {
        if (cooldown) return;
        const rect = button.getBoundingClientRect();
        celebrate(rect.left + rect.width / 2, rect.top + rect.height / 2);
        cooldown = true;
        setTimeout(() => {
          cooldown = false;
        }, 5000);
        await updateRSVP('attending');
      } else {
        if (urlData.originalName) {
          await updateRSVP('not_attending');
        }
        toast("We'll miss you! 🥺");
        const paymentSection = document.getElementById('payment');
        if (paymentSection) {
          paymentSection.scrollIntoView({ behavior: 'smooth', block: 'start' });
        }
      }
    });
  });
};

const init = () => {
  document.querySelectorAll('[data-delay]').forEach((el) => {
    const delay = el.dataset.delay;
    if (delay) el.style.setProperty('--delay', delay);
  });
  setupEmojiCursor();
  setupCurtain();
  setupParallax();
  setupRevealObserver();
  setupTypewriter();
  setupSpouseTilt();
  setupPayment();
  setupModal();
  setupRSVP();
};

window.addEventListener('DOMContentLoaded', init);
