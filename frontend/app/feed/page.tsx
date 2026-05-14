"use client";

import { useState } from "react";
import { motion } from "framer-motion";
import { TrendingUp, Flame, Zap } from "lucide-react";
import PredictionModal from "@/components/PredictionModal";

interface Trend {
  id: number;
  name: string;
  category: string;
  velocity: number;
  confidence: number;
  status: string;
  platform: string;
}

export default function FeedPage() {
  const [trends] = useState<Trend[]>([
    {
      id: 1,
      name: "AI Coding Assistants Surge",
      category: "tech",
      velocity: 85,
      confidence: 92,
      status: "trending",
      platform: "hackernews"
    },
    {
      id: 2,
      name: "Solana Meme Coins Rally",
      category: "crypto",
      velocity: 78,
      confidence: 88,
      status: "early",
      platform: "coingecko"
    },
    {
      id: 3,
      name: "Rust Web Frameworks",
      category: "tech",
      velocity: 65,
      confidence: 85,
      status: "early",
      platform: "github"
    }
  ]);

  const [modalOpen, setModalOpen] = useState(false);
  const [selectedTrend, setSelectedTrend] = useState<Trend | null>(null);

  const openPredictionModal = (trend: Trend) => {
    setSelectedTrend(trend);
    setModalOpen(true);
  };

  const getStatusColor = (status: string) => {
    switch (status) {
      case "early": return "text-cyber-green";
      case "trending": return "text-cyber-cyan";
      case "mainstream": return "text-cyber-magenta";
      default: return "text-gray-400";
    }
  };

  return (
    <div className="min-h-screen bg-cyber-dark">
      {/* Header */}
      <div className="border-b border-white/10 bg-cyber-darker/50 backdrop-blur-md sticky top-0 z-50">
        <div className="container mx-auto px-4 py-4">
          <h1 className="text-3xl font-bold bg-gradient-to-r from-cyber-cyan to-cyber-magenta bg-clip-text text-transparent">
            Signal Feed
          </h1>
        </div>
      </div>

      <div className="container mx-auto px-4 py-8">
        {/* Filters */}
        <div className="flex gap-3 mb-8 overflow-x-auto pb-2">
          {["All", "Crypto", "Tech", "Memes", "AI", "Startups"].map((filter) => (
            <button
              key={filter}
              className="px-4 py-2 rounded-full border border-cyber-cyan/30 hover:border-cyber-cyan hover:bg-cyber-cyan/10 transition-all whitespace-nowrap"
            >
              {filter}
            </button>
          ))}
        </div>

        {/* Trend Cards */}
        <div className="grid gap-6">
          {trends.map((trend, i) => (
            <motion.div
              key={trend.id}
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: i * 0.1 }}
              className="glow-card group cursor-pointer"
            >
              <div className="flex items-start justify-between mb-4">
                <div className="flex-1">
                  <div className="flex items-center gap-2 mb-2">
                    <span className={`text-xs font-mono uppercase ${getStatusColor(trend.status)}`}>
                      {trend.status}
                    </span>
                    <span className="text-xs text-gray-500">•</span>
                    <span className="text-xs text-gray-500">{trend.platform}</span>
                  </div>
                  <h3 className="text-xl font-bold mb-2 group-hover:text-cyber-cyan transition-colors">
                    {trend.name}
                  </h3>
                </div>
                <div className="pulse-indicator" />
              </div>

              {/* Metrics */}
              <div className="grid grid-cols-3 gap-4 mb-4">
                <div>
                  <div className="text-xs text-gray-500 mb-1">Velocity</div>
                  <div className="flex items-center gap-2">
                    <TrendingUp className="w-4 h-4 text-cyber-green" />
                    <span className="font-mono text-cyber-green">{trend.velocity}%</span>
                  </div>
                </div>
                <div>
                  <div className="text-xs text-gray-500 mb-1">Confidence</div>
                  <div className="flex items-center gap-2">
                    <Zap className="w-4 h-4 text-cyber-cyan" />
                    <span className="font-mono text-cyber-cyan">{trend.confidence}%</span>
                  </div>
                </div>
                <div>
                  <div className="text-xs text-gray-500 mb-1">Category</div>
                  <div className="flex items-center gap-2">
                    <Flame className="w-4 h-4 text-cyber-magenta" />
                    <span className="font-mono text-cyber-magenta">{trend.category}</span>
                  </div>
                </div>
              </div>

              {/* Progress Bar */}
              <div className="w-full h-1 bg-white/10 rounded-full overflow-hidden">
                <motion.div
                  initial={{ width: 0 }}
                  animate={{ width: `${trend.velocity}%` }}
                  transition={{ delay: i * 0.1 + 0.3, duration: 0.8 }}
                  className="h-full bg-gradient-to-r from-cyber-cyan to-cyber-green"
                />
              </div>

              {/* Actions */}
              <div className="flex gap-3 mt-4">
                <button 
                  onClick={() => openPredictionModal(trend)}
                  className="flex-1 py-2 rounded-lg bg-cyber-green/10 border border-cyber-green text-cyber-green hover:bg-cyber-green/20 transition-all text-sm font-semibold"
                >
                  🚀 Predict Explode
                </button>
                <button 
                  onClick={() => openPredictionModal(trend)}
                  className="flex-1 py-2 rounded-lg bg-cyber-magenta/10 border border-cyber-magenta text-cyber-magenta hover:bg-cyber-magenta/20 transition-all text-sm font-semibold"
                >
                  📉 Predict Fade
                </button>
              </div>
            </motion.div>
          ))}
        </div>
      </div>

      {/* Prediction Modal */}
      {selectedTrend && (
        <PredictionModal
          isOpen={modalOpen}
          onClose={() => setModalOpen(false)}
          trendName={selectedTrend.name}
          trendId={selectedTrend.id}
        />
      )}
    </div>
  );
}
