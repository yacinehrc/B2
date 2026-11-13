// Ancien code du projet démo de Vite, gardé pour montrer la base utilisée pour créer ce projet e-commerce avec React, TypeScript et Vite.

/*

import { useState, type ReactNode } from "react";
import ThemeContext from "./ThemeContext";

interface ThemeProviderProps {
  children: ReactNode;
}

const ThemeProvider = ({ children }: ThemeProviderProps) => {
  const [theme, setTheme] = useState<string>('light');

  const toggleTheme = () => {
    setTheme((prevValue) => (prevValue === 'light' ? 'dark' : 'light'));
  };

  return (
    <ThemeContext.Provider value={{ theme, toggleTheme }}>
      {children}
    </ThemeContext.Provider>
  );
};

export default ThemeProvider; */
