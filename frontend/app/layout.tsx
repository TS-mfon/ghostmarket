import type { Metadata } from "next";
import { Inter, JetBrains_Mono } from "next/font/google";
import Link from "next/link";
import WalletConnect from "@/components/WalletConnect";
import "./globals.css";

const inter = Inter({ subsets: ["latin"], variable: "--font-inter" });
const jetbrainsMono = JetBrains_Mono({ subsets: ["latin"], variable: "--font-jetbrains-mono" });

export const metadata: Metadata = {
  title: "GhostMarket - See What The World Wants Before It Knows",
  description: "AI-powered predictive demand marketplace. Detect emerging trends before they go mainstream.",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en" className={`${inter.variable} ${jetbrainsMono.variable}`}>
      <body className="font-sans">
        <nav className="fixed top-0 w-full z-50 border-b border-white/10 bg-cyber-darker/80 backdrop-blur-md">
          <div className="container mx-auto px-4 py-4 flex items-center justify-between">
            <Link href="/" className="text-2xl font-bold bg-gradient-to-r from-cyber-cyan to-cyber-magenta bg-clip-text text-transparent">
              👻 GhostMarket
            </Link>
            <div className="flex items-center gap-6">
              <Link href="/feed" className="hover:text-cyber-cyan transition-colors">Feed</Link>
              <Link href="/dashboard" className="hover:text-cyber-cyan transition-colors">Dashboard</Link>
              <Link href="/analytics" className="hover:text-cyber-cyan transition-colors">Analytics</Link>
              <WalletConnect />
            </div>
          </div>
        </nav>
        <div className="pt-16">
          {children}
        </div>
      </body>
    </html>
  );
}
