"use client";

import { motion } from "framer-motion";
import { Trophy, TrendingUp, Target, Award } from "lucide-react";

export default function DashboardPage() {
  const stats = {
    totalPredictions: 42,
    winRate: 68,
    reputation: 850,
    tier: "Hunter",
    earnings: 1250.5,
  };

  const predictions = [
    { id: 1, trend: "AI Coding Tools", type: "explode", confidence: 85, outcome: "correct", reward: 42.5 },
    { id: 2, trend: "Solana Memes", type: "explode", confidence: 70, outcome: "correct", reward: 35.0 },
    { id: 3, trend: "Web3 Gaming", type: "fade", confidence: 60, outcome: "pending", reward: 0 },
  ];

  return (
    <div className="min-h-screen bg-cyber-dark">
      <div className="border-b border-white/10 bg-cyber-darker/50 backdrop-blur-md">
        <div className="container mx-auto px-4 py-4">
          <h1 className="text-3xl font-bold bg-gradient-to-r from-cyber-cyan to-cyber-magenta bg-clip-text text-transparent">
            Dashboard
          </h1>
        </div>
      </div>

      <div className="container mx-auto px-4 py-8">
        {/* Stats Grid */}
        <div className="grid md:grid-cols-4 gap-6 mb-8">
          {[
            { icon: Target, label: "Total Predictions", value: stats.totalPredictions, color: "cyan" },
            { icon: TrendingUp, label: "Win Rate", value: `${stats.winRate}%`, color: "green" },
            { icon: Trophy, label: "Reputation", value: stats.reputation, color: "magenta" },
            { icon: Award, label: "Earnings", value: `${stats.earnings} GHOST`, color: "cyan" },
          ].map((stat, i) => (
            <motion.div
              key={i}
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: i * 0.1 }}
              className="glow-card"
            >
              <stat.icon className={`w-8 h-8 mb-3 text-cyber-${stat.color}`} />
              <div className="text-sm text-gray-400 mb-1">{stat.label}</div>
              <div className="text-2xl font-bold font-mono">{stat.value}</div>
            </motion.div>
          ))}
        </div>

        {/* Reputation Tier */}
        <div className="glow-card mb-8">
          <h2 className="text-xl font-bold mb-4">Reputation Tier</h2>
          <div className="flex items-center gap-4 mb-4">
            <div className="text-4xl">🏆</div>
            <div>
              <div className="text-2xl font-bold text-cyber-cyan">{stats.tier}</div>
              <div className="text-sm text-gray-400">{stats.reputation} / 1000 points</div>
            </div>
          </div>
          <div className="w-full h-2 bg-white/10 rounded-full overflow-hidden">
            <motion.div
              initial={{ width: 0 }}
              animate={{ width: `${(stats.reputation / 1000) * 100}%` }}
              transition={{ duration: 1 }}
              className="h-full bg-gradient-to-r from-cyber-cyan to-cyber-green"
            />
          </div>
        </div>

        {/* Prediction History */}
        <div className="glow-card">
          <h2 className="text-xl font-bold mb-6">Prediction History</h2>
          <div className="space-y-4">
            {predictions.map((pred) => (
              <div key={pred.id} className="glassmorphism rounded-lg p-4 flex items-center justify-between">
                <div className="flex-1">
                  <div className="font-semibold mb-1">{pred.trend}</div>
                  <div className="text-sm text-gray-400">
                    {pred.type === "explode" ? "🚀 Explode" : "📉 Fade"} • {pred.confidence}% confidence
                  </div>
                </div>
                <div className="text-right">
                  <div className={`text-sm font-semibold mb-1 ${
                    pred.outcome === "correct" ? "text-cyber-green" :
                    pred.outcome === "incorrect" ? "text-cyber-magenta" :
                    "text-gray-400"
                  }`}>
                    {pred.outcome.toUpperCase()}
                  </div>
                  {pred.reward > 0 && (
                    <div className="text-cyber-green font-mono">+{pred.reward} GHOST</div>
                  )}
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}
