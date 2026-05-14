"use client";

import { motion } from "framer-motion";
import Link from "next/link";

export default function Home() {
  return (
    <main className="min-h-screen relative overflow-hidden">
      {/* Animated background grid */}
      <div className="absolute inset-0 bg-[linear-gradient(to_right,#4f4f4f2e_1px,transparent_1px),linear-gradient(to_bottom,#4f4f4f2e_1px,transparent_1px)] bg-[size:64px_64px]" />
      
      {/* Glow effects */}
      <div className="absolute top-0 left-1/4 w-96 h-96 bg-cyber-cyan/20 rounded-full blur-[128px]" />
      <div className="absolute bottom-0 right-1/4 w-96 h-96 bg-cyber-magenta/20 rounded-full blur-[128px]" />

      <div className="relative z-10 container mx-auto px-4 py-20">
        {/* Hero Section */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.8 }}
          className="text-center max-w-4xl mx-auto"
        >
          <motion.div
            initial={{ scale: 0.9 }}
            animate={{ scale: 1 }}
            transition={{ duration: 0.5 }}
            className="inline-block mb-6"
          >
            <span className="text-cyber-cyan text-sm font-mono tracking-wider">
              ⚡ POWERED BY GENLAYER AI
            </span>
          </motion.div>

          <h1 className="text-6xl md:text-8xl font-bold mb-6 bg-gradient-to-r from-cyber-cyan via-cyber-magenta to-cyber-green bg-clip-text text-transparent">
            GhostMarket
          </h1>

          <p className="text-2xl md:text-3xl mb-4 text-gray-300">
            See what the world wants
          </p>
          <p className="text-2xl md:text-3xl mb-12 text-gray-300">
            before the world knows it.
          </p>

          <p className="text-lg text-gray-400 mb-12 max-w-2xl mx-auto">
            AI-powered predictive demand marketplace. Detect emerging trends in crypto, tech, memes, and startups before they go mainstream.
          </p>

          <div className="flex gap-4 justify-center">
            <Link href="/feed">
              <motion.button
                whileHover={{ scale: 1.05 }}
                whileTap={{ scale: 0.95 }}
                className="neon-button text-lg"
              >
                Enter The Signal Feed
              </motion.button>
            </Link>
            
            <Link href="/about">
              <motion.button
                whileHover={{ scale: 1.05 }}
                whileTap={{ scale: 0.95 }}
                className="px-6 py-3 rounded-lg font-semibold border border-white/20 hover:border-white/40 transition-all"
              >
                Learn More
              </motion.button>
            </Link>
          </div>
        </motion.div>

        {/* Feature Cards */}
        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ delay: 0.5, duration: 0.8 }}
          className="grid md:grid-cols-3 gap-6 mt-20"
        >
          {[
            {
              icon: "🔮",
              title: "Trend Detection",
              description: "Real-time discovery from Hacker News, CoinGecko, GitHub"
            },
            {
              icon: "🎯",
              title: "Predictions",
              description: "Binary predictions with confidence staking"
            },
            {
              icon: "🏆",
              title: "Reputation",
              description: "Accuracy-based scoring with decay mechanics"
            }
          ].map((feature, i) => (
            <motion.div
              key={i}
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.7 + i * 0.1 }}
              className="glow-card"
            >
              <div className="text-4xl mb-4">{feature.icon}</div>
              <h3 className="text-xl font-bold mb-2 text-cyber-cyan">{feature.title}</h3>
              <p className="text-gray-400">{feature.description}</p>
            </motion.div>
          ))}
        </motion.div>
      </div>
    </main>
  );
}
