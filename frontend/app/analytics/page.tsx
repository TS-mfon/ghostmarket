"use client";

import { useState } from "react";
import TrendTimeline from "@/components/TrendTimeline";
import VelocityChart from "@/components/VelocityChart";

export default function AnalyticsPage() {
  const timelineData = [
    { date: "2024-01", velocity: 45 },
    { date: "2024-02", velocity: 62 },
    { date: "2024-03", velocity: 78 },
    { date: "2024-04", velocity: 85 },
  ];

  const velocityData = [
    { hour: "00:00", velocity: 65 },
    { hour: "06:00", velocity: 72 },
    { hour: "12:00", velocity: 85 },
    { hour: "18:00", velocity: 78 },
  ];

  return (
    <div className="min-h-screen bg-cyber-dark">
      <div className="border-b border-white/10 bg-cyber-darker/50 backdrop-blur-md">
        <div className="container mx-auto px-4 py-4">
          <h1 className="text-3xl font-bold bg-gradient-to-r from-cyber-cyan to-cyber-magenta bg-clip-text text-transparent">
            Analytics
          </h1>
        </div>
      </div>

      <div className="container mx-auto px-4 py-8 space-y-8">
        <TrendTimeline data={timelineData} />
        <VelocityChart data={velocityData} />
      </div>
    </div>
  );
}
