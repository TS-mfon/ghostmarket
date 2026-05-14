"use client";

import { useState } from "react";
import { motion } from "framer-motion";
import { Send, Users, Lock } from "lucide-react";

export default function WarRoomPage() {
  const [message, setMessage] = useState("");
  const [messages] = useState([
    { id: 1, user: "0x1234...5678", content: "This trend is definitely going to explode", timestamp: "2m ago" },
    { id: 2, user: "0x8765...4321", content: "I'm not so sure, velocity is slowing down", timestamp: "1m ago" },
  ]);

  const members = [
    { address: "0x1234...5678", reputation: 850, tier: "Hunter", online: true },
    { address: "0x8765...4321", reputation: 650, tier: "Explorer", online: true },
    { address: "0xabcd...ef01", reputation: 450, tier: "Explorer", online: false },
  ];

  return (
    <div className="min-h-screen bg-cyber-dark">
      <div className="border-b border-white/10 bg-cyber-darker/50 backdrop-blur-md">
        <div className="container mx-auto px-4 py-4">
          <div className="flex items-center justify-between">
            <div>
              <h1 className="text-2xl font-bold text-cyber-cyan">AI Coding Tools War Room</h1>
              <div className="text-sm text-gray-400 flex items-center gap-2 mt-1">
                <Users className="w-4 h-4" />
                {members.length} members
              </div>
            </div>
            <div className="flex items-center gap-2 text-cyber-green">
              <Lock className="w-4 h-4" />
              <span className="text-sm">Staked Access</span>
            </div>
          </div>
        </div>
      </div>

      <div className="container mx-auto px-4 py-6">
        <div className="grid md:grid-cols-[1fr_300px] gap-6">
          {/* Chat Area */}
          <div className="glow-card flex flex-col h-[calc(100vh-200px)]">
            {/* Messages */}
            <div className="flex-1 overflow-y-auto space-y-4 mb-4">
              {messages.map((msg) => (
                <motion.div
                  key={msg.id}
                  initial={{ opacity: 0, y: 10 }}
                  animate={{ opacity: 1, y: 0 }}
                  className="glassmorphism rounded-lg p-4"
                >
                  <div className="flex items-center gap-2 mb-2">
                    <div className="w-8 h-8 rounded-full bg-gradient-to-r from-cyber-cyan to-cyber-magenta" />
                    <span className="font-mono text-sm text-cyber-cyan">{msg.user}</span>
                    <span className="text-xs text-gray-500">{msg.timestamp}</span>
                  </div>
                  <p className="text-gray-300">{msg.content}</p>
                </motion.div>
              ))}
            </div>

            {/* Input */}
            <div className="flex gap-3">
              <input
                type="text"
                value={message}
                onChange={(e) => setMessage(e.target.value)}
                placeholder="Type your message..."
                className="flex-1 bg-white/5 border border-white/10 rounded-lg px-4 py-3 focus:outline-none focus:border-cyber-cyan transition-colors"
              />
              <button className="neon-button px-6">
                <Send className="w-5 h-5" />
              </button>
            </div>
          </div>

          {/* Members Sidebar */}
          <div className="glow-card">
            <h3 className="text-lg font-bold mb-4 flex items-center gap-2">
              <Users className="w-5 h-5 text-cyber-cyan" />
              Members
            </h3>
            <div className="space-y-3">
              {members.map((member, i) => (
                <div key={i} className="glassmorphism rounded-lg p-3">
                  <div className="flex items-center gap-2 mb-2">
                    <div className={`w-2 h-2 rounded-full ${member.online ? "bg-cyber-green animate-pulse" : "bg-gray-600"}`} />
                    <span className="font-mono text-sm">{member.address}</span>
                  </div>
                  <div className="flex items-center justify-between text-xs">
                    <span className="text-gray-400">{member.tier}</span>
                    <span className="text-cyber-cyan font-mono">{member.reputation}</span>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
