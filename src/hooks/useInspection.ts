/**
 * Custom hooks for inspection functionality
 */
import { useState, useCallback } from 'react';
import { useDispatch } from 'react-redux';
import { Inspection } from '../types';
import { inspectionService } from '../services/inspectionService';
import { addInspection, updateInspection } from '../store/slices/inspectionsSlice';

export const useInspection = () => {
  const dispatch = useDispatch();
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const createInspection = useCallback(async (data: Partial<Inspection>) => {
    setLoading(true);
    setError(null);
    try {
      const response = await inspectionService.create(data);
      dispatch(addInspection(response));
      return response;
    } catch (err) {
      setError(err.message);
      throw err;
    } finally {
      setLoading(false);
    }
  }, [dispatch]);

  const updateInspectionStatus = useCallback(async (id: string, status: string) => {
    setLoading(true);
    setError(null);
    try {
      const response = await inspectionService.update(id, { status });
      dispatch(updateInspection(response));
      return response;
    } catch (err) {
      setError(err.message);
      throw err;
    } finally {
      setLoading(false);
    }
  }, [dispatch]);

  return {
    loading,
    error,
    createInspection,
    updateInspectionStatus,
  };
}; 