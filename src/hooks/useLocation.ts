import { useState, useEffect } from 'react';

interface Coordinates {
  latitude: number;
  longitude: number;
}

export const useLocation = () => {
  const [coordinates, setCoordinates] = useState<Coordinates | null>(null);

  useEffect(() => {
    // Mock location for now - replace with actual location logic
    setCoordinates({
      latitude: 0,
      longitude: 0
    });
  }, []);

  return { coordinates };
}; 