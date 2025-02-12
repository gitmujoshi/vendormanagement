import React from 'react';
import { render, fireEvent } from '@testing-library/react-native';
import InspectionCard from '../index';

const mockInspection = {
  id: '1',
  stationNumber: 'ST001',
  propertyName: 'Test Property',
  date: '2024-03-21',
  status: 'completed',
  assignedTo: 'John Doe',
  findings: ['Test finding'],
  images: ['test.jpg'],
};

describe('InspectionCard', () => {
  it('renders correctly', () => {
    const { getByText } = render(<InspectionCard inspection={mockInspection} />);
    expect(getByText('ST001')).toBeTruthy();
    expect(getByText('Test Property')).toBeTruthy();
  });

  it('displays status chip correctly', () => {
    const { getByText } = render(<InspectionCard inspection={mockInspection} />);
    const statusChip = getByText('completed');
    expect(statusChip).toBeTruthy();
  });
}); 