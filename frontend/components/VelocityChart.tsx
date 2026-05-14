"use client";

import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from "recharts";

interface VelocityChartProps {
  data: Array<{ hour: string; velocity: number }>;
}

export default function VelocityChart({ data }: VelocityChartProps) {
  return (
    <div className="glow-card">
      <h3 className="text-lg font-bold mb-4">Real-Time Velocity</h3>
      <ResponsiveContainer width="100%" height={300}>
        <LineChart data={data}>
          <CartesianGrid strokeDasharray="3 3" stroke="#ffffff10" />
          <XAxis dataKey="hour" stroke="#888" />
          <YAxis stroke="#888" />
          <Tooltip
            contentStyle={{
              backgroundColor: "#12121a",
              border: "1px solid #ffffff20",
              borderRadius: "8px",
            }}
          />
          <Line type="monotone" dataKey="velocity" stroke="#00ff00" strokeWidth={2} />
        </LineChart>
      </ResponsiveContainer>
    </div>
  );
}
