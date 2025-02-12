import React, { useState } from 'react';
import { View, ScrollView, StyleSheet } from 'react-native';
import { DataTable, Text, Button, TextInput, Menu, Divider } from 'react-native-paper';
import DateTimePicker from '@react-native-community/datetimepicker';

interface Filters {
  startDate: Date | null;
  endDate: Date | null;
  property: string;
  reportType: string;
}

const Reports = () => {
  const [filters, setFilters] = useState<Filters>({
    startDate: new Date(),
    endDate: new Date(),
    property: '',
    reportType: ''
  });

  const reportTypes = [
    { value: 'inspection', label: 'Inspection Report' },
    { value: 'maintenance', label: 'Maintenance Report' },
    { value: 'efficiency', label: 'Efficiency Report' },
    { value: 'cost', label: 'Cost Analysis' },
  ];

  const generateReport = () => {
    console.log('Generating report with filters:', filters);
  };

  return (
    <ScrollView style={styles.container}>
      <Text style={styles.title}>Reports</Text>

      <View style={styles.filtersContainer}>
        <DateTimePicker
          value={filters.startDate || new Date()}
          onChange={(event, date) => setFilters({ ...filters, startDate: date || null })}
        />
        <DateTimePicker
          value={filters.endDate || new Date()}
          onChange={(event, date) => setFilters({ ...filters, endDate: date || null })}
        />
        <TextInput
          label="Property"
          value={filters.property}
          onChangeText={(text) => setFilters({ ...filters, property: text })}
        />
        <TextInput
          label="Report Type"
          value={filters.reportType}
          onChangeText={(text) => setFilters({ ...filters, reportType: text })}
        />
        <Button mode="contained" onPress={generateReport}>
          Generate Report
        </Button>
      </View>

      <DataTable>
        <DataTable.Header>
          <DataTable.Title>Report Name</DataTable.Title>
          <DataTable.Title>Date</DataTable.Title>
          <DataTable.Title>Actions</DataTable.Title>
        </DataTable.Header>

        <DataTable.Row>
          <DataTable.Cell>March 2024 Summary</DataTable.Cell>
          <DataTable.Cell>2024-03-21</DataTable.Cell>
          <DataTable.Cell>
            <Button icon="download">Download</Button>
          </DataTable.Cell>
        </DataTable.Row>
      </DataTable>
    </ScrollView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: 16,
  },
  title: {
    fontSize: 24,
    marginBottom: 16,
  },
  filtersContainer: {
    gap: 16,
    marginBottom: 24,
  },
});

export default Reports; 