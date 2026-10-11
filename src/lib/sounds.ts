// Notification sound utilities
export const notificationSounds = {
  success: () => {
    const audio = new Audio('/sounds/success.mp3');
    audio.volume = 0.3;
    audio.play().catch(() => {
      // Ignore autoplay errors
    });
  },
  error: () => {
    const audio = new Audio('/sounds/error.mp3');
    audio.volume = 0.3;
    audio.play().catch(() => {
      // Ignore autoplay errors
    });
  },
  warning: () => {
    const audio = new Audio('/sounds/warning.mp3');
    audio.volume = 0.3;
    audio.play().catch(() => {
      // Ignore autoplay errors
    });
  },
  info: () => {
    const audio = new Audio('/sounds/info.mp3');
    audio.volume = 0.3;
    audio.play().catch(() => {
      // Ignore autoplay errors
    });
  },
  message: () => {
    const audio = new Audio('/sounds/message.mp3');
    audio.volume = 0.3;
    audio.play().catch(() => {
      // Ignore autoplay errors
    });
  },
};

// Sound settings
export const soundSettings = {
  enabled: true,
  volume: 0.3,
};

export const toggleSound = () => {
  soundSettings.enabled = !soundSettings.enabled;
};

export const setVolume = (volume: number) => {
  soundSettings.volume = Math.max(0, Math.min(1, volume));
};

export const playSound = (type: keyof typeof notificationSounds) => {
  if (soundSettings.enabled) {
    notificationSounds[type]();
  }
};