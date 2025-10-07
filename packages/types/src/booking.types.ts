export enum BookingStatus {
  PENDING = 'pending',
  CONFIRMED = 'confirmed',
  CANCELLED = 'cancelled',
  COMPLETED = 'completed',
}

export interface Booking {
  id: string
  userId: string
  eventDate: Date
  eventType: string
  guestCount: number
  status: BookingStatus
  notes?: string
  createdAt: Date
  updatedAt: Date
}

export interface CreateBookingRequest {
  eventDate: string
  eventType: string
  guestCount: number
  notes?: string
}

export interface UpdateBookingRequest {
  eventDate?: string
  eventType?: string
  guestCount?: number
  status?: BookingStatus
  notes?: string
}

export interface BookingResponse {
  id: string
  userId: string
  eventDate: string
  eventType: string
  guestCount: number
  status: BookingStatus
  notes?: string
  createdAt: string
  updatedAt: string
}
