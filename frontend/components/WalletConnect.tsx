"use client";

import { useState } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { Wallet, X } from "lucide-react";

export default function WalletConnect() {
  const [isOpen, setIsOpen] = useState(false);
  const [connected, setConnected] = useState(false);
  const [address, setAddress] = useState("");

  const connectWallet = async (type: string) => {
    const mockAddress = "0x" + Math.random().toString(16).slice(2, 42);
    setAddress(mockAddress);
    setConnected(true);
    setIsOpen(false);
  };

  return (
    <>
      <button
        onClick={() => (connected ? null : setIsOpen(true))}
        className="neon-button px-6 py-2 flex items-center gap-2"
      >
        <Wallet className="w-4 h-4" />
        {connected ? `${address.slice(0, 6)}...${address.slice(-4)}` : "Connect Wallet"}
      </button>

      <AnimatePresence>
        {isOpen && (
          <div className="fixed inset-0 z-50 flex items-center justify-center p-4">
            <motion.div
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={{ opacity: 0 }}
              className="absolute inset-0 bg-black/80 backdrop-blur-sm"
              onClick={() => setIsOpen(false)}
            />

            <motion.div
              initial={{ scale: 0.9, opacity: 0 }}
              animate={{ scale: 1, opacity: 1 }}
              exit={{ scale: 0.9, opacity: 0 }}
              className="relative w-full max-w-md glassmorphism rounded-2xl p-8"
            >
              <button
                onClick={() => setIsOpen(false)}
                className="absolute top-4 right-4 text-gray-400 hover:text-white"
              >
                <X className="w-6 h-6" />
              </button>

              <h2 className="text-2xl font-bold mb-6 text-cyber-cyan">Connect Wallet</h2>

              <div className="space-y-3">
                {["MetaMask", "WalletConnect", "Coinbase Wallet"].map((wallet) => (
                  <button
                    key={wallet}
                    onClick={() => connectWallet(wallet)}
                    className="w-full p-4 glassmorphism rounded-lg hover:border-cyber-cyan border border-white/10 transition-all"
                  >
                    <div className="flex items-center gap-3">
                      <div className="w-10 h-10 rounded-full bg-gradient-to-r from-cyber-cyan to-cyber-magenta" />
                      <span className="font-semibold">{wallet}</span>
                    </div>
                  </button>
                ))}
              </div>
            </motion.div>
          </div>
        )}
      </AnimatePresence>
    </>
  );
}
