import React from 'react';
import { View } from 'react-native';
import { Surface, Text } from 'react-native-paper';
import { Calendar } from 'react-native-calendars';

interface InspectionCalendarProps {
  inspections: any[];
}

const InspectionCalendar: React.FC<InspectionCalendarProps> = ({ inspections }) => {
  const markedDates = inspections.reduce((acc, inspection) => ({
    ...acc,
    [inspection.date]: {
      marked: true,
      dotColor: inspection.status === 'completed' ? '#66bb6a' : '#ffa726'
    }
  }), {});

  return (
    <Surface style={{ padding: 16 }}>
      <Calendar markedDates={markedDates} />
    </Surface>
  );
};

export default InspectionCalendar; 