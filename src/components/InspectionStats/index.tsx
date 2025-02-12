import React from 'react';
import {
  Grid,
  Paper,
  Typography,
  Box,
} from '@mui/material';
import {
  BarChart,
  Bar,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  Legend,
  PieChart,
  Pie,
  Cell,
  ResponsiveContainer,
} from 'recharts';

interface InspectionStatsProps {
  inspections: any[];
}

const COLORS = ['#0088FE', '#00C49F', '#FFBB28', '#FF8042'];

const InspectionStats: React.FC<InspectionStatsProps> = ({ inspections }) => {
  const statusData = [
    { name: 'Pending', value: inspections.filter(i => i.status === 'pending').length },
    { name: 'In Progress', value: inspections.filter(i => i.status === 'in-progress').length },
    { name: 'Completed', value: inspections.filter(i => i.status === 'completed').length },
    { name: 'Failed', value: inspections.filter(i => i.status === 'failed').length },
  ];

  const monthlyData = [
    { month: 'Jan', inspections: 30 },
    { month: 'Feb', inspections: 45 },
    { month: 'Mar', inspections: 55 },
    // Add more monthly data
  ];

  return (
    <Grid container spacing={3}>
      <Grid item xs={12} md={6}>
        <Paper sx={{ p: 2, height: '400px' }}>
          <Typography variant="h6" gutterBottom>
            Inspection Status Distribution
          </Typography>
          <ResponsiveContainer width="100%" height="90%">
            <PieChart>
              <Pie
                data={statusData}
                dataKey="value"
                nameKey="name"
                cx="50%"
                cy="50%"
                outerRadius={100}
                label
              >
                {statusData.map((entry, index) => (
                  <Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} />
                ))}
              </Pie>
              <Tooltip />
              <Legend />
            </PieChart>
          </ResponsiveContainer>
        </Paper>
      </Grid>

      <Grid item xs={12} md={6}>
        <Paper sx={{ p: 2, height: '400px' }}>
          <Typography variant="h6" gutterBottom>
            Monthly Inspections
          </Typography>
          <ResponsiveContainer width="100%" height="90%">
            <BarChart data={monthlyData}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="month" />
              <YAxis />
              <Tooltip />
              <Bar dataKey="inspections" fill="#8884d8" />
            </BarChart>
          </ResponsiveContainer>
        </Paper>
      </Grid>

      <Grid item xs={12}>
        <Paper sx={{ p: 2 }}>
          <Typography variant="h6" gutterBottom>
            Key Metrics
          </Typography>
          <Grid container spacing={3}>
            <Grid item xs={12} sm={3}>
              <Box textAlign="center">
                <Typography variant="h4" color="primary">
                  {inspections.length}
                </Typography>
                <Typography variant="body2" color="text.secondary">
                  Total Inspections
                </Typography>
              </Box>
            </Grid>
            <Grid item xs={12} sm={3}>
              <Box textAlign="center">
                <Typography variant="h4" color="success.main">
                  {inspections.filter(i => i.status === 'completed').length}
                </Typography>
                <Typography variant="body2" color="text.secondary">
                  Completed
                </Typography>
              </Box>
            </Grid>
            <Grid item xs={12} sm={3}>
              <Box textAlign="center">
                <Typography variant="h4" color="warning.main">
                  {inspections.filter(i => i.status === 'pending').length}
                </Typography>
                <Typography variant="body2" color="text.secondary">
                  Pending
                </Typography>
              </Box>
            </Grid>
            <Grid item xs={12} sm={3}>
              <Box textAlign="center">
                <Typography variant="h4" color="error.main">
                  {inspections.filter(i => i.status === 'failed').length}
                </Typography>
                <Typography variant="body2" color="text.secondary">
                  Failed
                </Typography>
              </Box>
            </Grid>
          </Grid>
        </Paper>
      </Grid>
    </Grid>
  );
};

export default InspectionStats; 