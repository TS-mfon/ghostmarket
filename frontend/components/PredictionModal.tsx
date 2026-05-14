"use client";

import { useState } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { X, TrendingUp, TrendingDown } from "lucide-react";

interface PredictionModalProps {
  isOpen: boolean;
  onClose: () => void;
  trendName: string;
  trendId: number;
}

export default function PredictionModal({ isOpen, onClose, trendName, trendId }: PredictionModalProps) {
  const [predictionType, setPredictionType] = useState<"explode" | "fade" | null>(null);
  const [confidence, setConfidence] = useState(50);
  const [timeframe, setTimeframe] = useState(7);

  const calculateReward = () => {
    const baseReward = confidence * 0.1;
    const timeMultiplier = timeframe === 1 ? 1.5 : timeframe === 7 ? 1.0 : 0.8;
    return (baseReward * timeMultiplier).toFixed(2);
  };

  const handleSubmit = () => {
    console.log({ trendId, predictionType, confidence, timeframe });
    onClose();
  };

  return (
    <AnimatePresence>
      {isOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4">
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            className="absolute inset-0 bg-black/80 backdrop-blur-sm"
            onClick={onClose}
          />
          
          <motion.div
            initial={{ scale: 0.9, opacity: 0 }}
            animate={{ scale: 1, opacity: 1 }}
            exit={{ scale: 0.9, opacity: 0 }}
            className="relative w-full max-w-2xl glassmorphism rounded-2xl p-8"
          >
            <button
              onClick={onClose}
              className="absolute top-4 right-4 text-gray-400 hover:text-white"
            >
              <X className="w-6 h-6" />
            </button>

            <h2 className="text-3xl font-bold mb-2 bg-gradient-to-r from-cyber-cyan to-cyber-magenta bg-clip-text text-transparent">
              Make Prediction
            </h2>
            <p className="text-gray-400 mb-8">{trendName}</p>

            {/* Prediction Type */}
            <div className="grid grid-cols-2 gap-4 mb-8">
              <motion.button
                whileHover={{ scale: 1.02 }}
                whileTap={{ scale: 0.98 }}
                onClick={() => setPredictionType("explode")}
                className={`p-6 rounded-xl border-2 transition-all ${
                  predictionType === "explode"
                    ? "border-cyber-green bg-cyber-green/20 shadow-glow-green"
                    : "border-white/10 hover:border-cyber-green/50"
                }`}
              >
                <TrendingUp className="w-12 h-12 mx-auto mb-3 text-cyber-green" />
                <div className="text-xl font-bold text-cyber-green">WILL EXPLODE 🚀</div>
              </motion.button>

              <motion.button
                whileHover={{ scale: 1.02 }}
                whileTap={{ scale: 0.98 }}
                onClick={() => setPredictionType("fade")}
                className={`p-6 rounded-xl border-2 transition-all ${
                  predictionType === "fade"
                    ? "border-cyber-magenta bg-cyber-magenta/20 shadow-glow-magenta"
                    : "border-white/10 hover:border-cyber-magenta/50"
                }`}
              >
                <TrendingDown className="w-12 h-12 mx-auto mb-3 text-cyber-magenta" />
                <div className="text-xl font-bold text-cyber-magenta">WILL FADE 📉</div>
              </motion.button>
            </div>

            {/* Confidence Slider */}
            <div className="mb-8">
              <div className="flex justify-between mb-2">
                <label className="text-sm text-gray-400">Confidence Level</label>
                <span className="text-cyber-cyan font-mono font-bold">{confidence}%</span>
              </div>
              <input
                type="range"
                min="0"
                max="100"
                value={confidence}
                onChange={(e) => setConfidence(Number(e.target.value))}
                className="w-full h-2 rounded-full appearance-none cursor-pointer"
                style={{
                  background: `linear-gradient(to right, #ff0000 0%, #ffff00 50%, #00ff00 100%)`,
                }}
              />
            </div>

            {/* Timeframe */}
            <div className="mb-8">
              <label className="text-sm text-gray-400 mb-3 block">Timeframe</label>
              <div className="flex gap-3">
                {[
                  { days: 1, label: "1 Day" },
                  { days: 7, label: "1 Week" },
                  { days: 30, label: "1 Month" },
                ].map((option) => (
                  <button
                    key={option.days}
                    onClick={() => setTimeframe(option.days)}
                    className={`flex-1 py-3 rounded-lg border transition-all ${
                      timeframe === option.days
                        ? "border-cyber-cyan bg-cyber-cyan/20 text-cyber-cyan"
                        : "border-white/10 hover:border-white/30"
                    }`}
                  >
                    {option.label}
                  </button>
                ))}
              </div>
            </div>

            {/* Reward Calculation */}
            <div className="glassmorphism rounded-lg p-4 mb-8">
              <div className="flex justify-between items-center">
                <span className="text-gray-400">Potential Reward</span>
                <span className="text-2xl font-bold text-cyber-green font-mono">
                  {calculateReward()} GHOST
                </span>
              </div>
            </div>

            {/* Submit */}
            <button
              onClick={handleSubmit}
              disabled={!predictionType}
              className="w-full neon-button py-4 text-lg disabled:opacity-50 disabled:cursor-not-allowed"
            >
              Submit Prediction
            </button>
          </motion.div>
        </div>
      )}
    </AnimatePresence>
  );
}
