"use client";

import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from "recharts";

interface TrendTimelineProps {
  data: Array<{ date: string; velocity: number }>;
}

export default function TrendTimeline({ data }: TrendTimelineProps) {
  return (
    <div className="glow-card">
      <h3 className="text-lg font-bold mb-4">Trend Timeline</h3>
      <ResponsiveContainer width="100%" height={300}>
        <LineChart data={data}>
          <defs>
            <linearGradient id="velocityGradient" x1="0" y1="0" x2="0" y2="1">
              <stop offset="5%" stopColor="#00ffff" stopOpacity={0.8}/>
              <stop offset="95%" stopColor="#00ffff" stopOpacity={0}/>
            </linearGradient>
          </defs>
          <CartesianGrid strokeDasharray="3 3" stroke="#ffffff10" />
          <XAxis dataKey="date" stroke="#888" />
          <YAxis stroke="#888" />
          <Tooltip
            contentStyle={{
              backgroundColor: "#12121a",
              border: "1px solid #ffffff20",
              borderRadius: "8px",
            }}
          />
          <Line
            type="monotone"
            dataKey="velocity"
            stroke="#00ffff"
            strokeWidth={2}
            fill="url(#velocityGradient)"
          />
        </LineChart>
      </ResponsiveContainer>
    </div>
  );
}
