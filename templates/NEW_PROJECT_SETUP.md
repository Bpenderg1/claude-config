# SME Prototype: New Project Setup Guide

Follow these steps to start a new SME prototype project with all the proper standards in place.

## Quick Start

### Step 1: Create Project with Next.js

```bash
# Create new Next.js project with TypeScript and App Router
npx create-next-app@latest your-project-name --typescript --app --eslint

# Navigate to project
cd your-project-name
```

### Step 2: Copy Templates

Copy these files from the templates folder to your new project:

```
templates/CLAUDE.md.template     -> your-project-name/CLAUDE.md
templates/.claude/               -> your-project-name/.claude/
```

Then customize CLAUDE.md with your project-specific details.

### Step 3: Create Required Directories

```bash
# Create the standard directory structure
mkdir -p lib/services lib/config docs/decisions tests/unit tests/integration
```

### Step 4: Set Up Configuration

Create `/lib/config.ts`:

```typescript
// lib/config.ts
export const config = {
  // App Configuration
  appName: process.env.NEXT_PUBLIC_APP_NAME || 'SME Prototype',
  baseUrl: process.env.APP_BASE_URL || 'http://localhost:3000',

  // Mode Configuration
  isDemoMode: process.env.DEMO_MODE === 'true',
  isProduction: process.env.NODE_ENV === 'production',

  // Integration Configuration (add as needed)
  sharepoint: {
    siteUrl: process.env.SHAREPOINT_SITE_URL || '',
    listId: process.env.SHAREPOINT_LIST_ID || '',
  },

  // Future Auth (stubbed)
  auth: {
    tenantId: process.env.AAD_TENANT_ID || '',
    clientId: process.env.AAD_CLIENT_ID || '',
  },
} as const;

// Type for the config
export type Config = typeof config;
```

### Step 5: Set Up Types

Create `/lib/types.ts`:

```typescript
// lib/types.ts

// Standard API response types
export interface ApiSuccess<T> {
  ok: true;
  data: T;
}

export interface ApiError {
  ok: false;
  error: {
    code: string;
    message: string;
  };
}

export type ApiResponse<T> = ApiSuccess<T> | ApiError;

// Helper to create responses
export const success = <T>(data: T): ApiSuccess<T> => ({ ok: true, data });
export const error = (code: string, message: string): ApiError => ({
  ok: false,
  error: { code, message },
});

// User types (for future auth)
export interface User {
  id: string;
  email: string;
  name: string;
  role: 'admin' | 'user' | 'viewer';
}

// Add your domain types below
// Example:
// export interface Project {
//   id: string;
//   name: string;
//   status: 'active' | 'archived';
//   createdAt: Date;
// }
```

### Step 6: Set Up Service Pattern

Create the service interface in `/lib/services/index.ts`:

```typescript
// lib/services/index.ts
import { config } from '@/lib/config';

// Import real and mock implementations
import { realService } from './realService';
import { mockService } from './mockService';

// Export the appropriate service based on mode
export const appService = config.isDemoMode ? mockService : realService;

// Re-export types
export type { AppService } from './types';
```

Create service types in `/lib/services/types.ts`:

```typescript
// lib/services/types.ts
import { ApiResponse } from '@/lib/types';

// Define your service interface
export interface AppService {
  // Example methods - customize for your app
  getItems: () => Promise<ApiResponse<Item[]>>;
  getItem: (id: string) => Promise<ApiResponse<Item>>;
  createItem: (data: CreateItemInput) => Promise<ApiResponse<Item>>;
  updateItem: (id: string, data: UpdateItemInput) => Promise<ApiResponse<Item>>;
  deleteItem: (id: string) => Promise<ApiResponse<void>>;
}

// Example types - customize for your app
export interface Item {
  id: string;
  name: string;
  // ... other fields
}

export interface CreateItemInput {
  name: string;
  // ... other fields
}

export interface UpdateItemInput {
  name?: string;
  // ... other fields
}
```

Create mock service in `/lib/services/mockService.ts`:

```typescript
// lib/services/mockService.ts
import { AppService, Item } from './types';
import { success, error } from '@/lib/types';

// Deterministic mock data
const mockItems: Item[] = [
  { id: '1', name: 'Demo Item 1' },
  { id: '2', name: 'Demo Item 2' },
  { id: '3', name: 'Demo Item 3' },
];

export const mockService: AppService = {
  async getItems() {
    // Simulate network delay
    await new Promise(resolve => setTimeout(resolve, 100));
    return success([...mockItems]);
  },

  async getItem(id) {
    await new Promise(resolve => setTimeout(resolve, 50));
    const item = mockItems.find(i => i.id === id);
    if (!item) {
      return error('NOT_FOUND', `Item ${id} not found`);
    }
    return success({ ...item });
  },

  async createItem(data) {
    await new Promise(resolve => setTimeout(resolve, 100));
    const newItem: Item = {
      id: String(Date.now()),
      ...data,
    };
    mockItems.push(newItem);
    return success(newItem);
  },

  async updateItem(id, data) {
    await new Promise(resolve => setTimeout(resolve, 100));
    const index = mockItems.findIndex(i => i.id === id);
    if (index === -1) {
      return error('NOT_FOUND', `Item ${id} not found`);
    }
    mockItems[index] = { ...mockItems[index], ...data };
    return success(mockItems[index]);
  },

  async deleteItem(id) {
    await new Promise(resolve => setTimeout(resolve, 100));
    const index = mockItems.findIndex(i => i.id === id);
    if (index === -1) {
      return error('NOT_FOUND', `Item ${id} not found`);
    }
    mockItems.splice(index, 1);
    return success(undefined);
  },
};
```

Create placeholder real service in `/lib/services/realService.ts`:

```typescript
// lib/services/realService.ts
import { AppService } from './types';
import { error } from '@/lib/types';

// TODO: Implement real service when integrations are ready
export const realService: AppService = {
  async getItems() {
    // TODO: Implement with real API
    return error('NOT_IMPLEMENTED', 'Real service not yet implemented');
  },

  async getItem(id) {
    return error('NOT_IMPLEMENTED', 'Real service not yet implemented');
  },

  async createItem(data) {
    return error('NOT_IMPLEMENTED', 'Real service not yet implemented');
  },

  async updateItem(id, data) {
    return error('NOT_IMPLEMENTED', 'Real service not yet implemented');
  },

  async deleteItem(id) {
    return error('NOT_IMPLEMENTED', 'Real service not yet implemented');
  },
};
```

### Step 7: Create Environment Files

Create `.env.example`:

```bash
# App Configuration
NEXT_PUBLIC_APP_NAME="Your App Name"
APP_BASE_URL="http://localhost:3000"

# Mode Configuration
DEMO_MODE="true"

# SharePoint Integration (when ready)
SHAREPOINT_SITE_URL=""
SHAREPOINT_LIST_ID=""

# Azure AD (when ready)
AAD_TENANT_ID=""
AAD_CLIENT_ID=""
```

Create `.env.local` (gitignored):

```bash
DEMO_MODE="true"
```

Update `.gitignore` to include:

```
.env.local
.env.production
.env*.local
```

### Step 8: Create Initial API Route

Create `/app/api/health/route.ts`:

```typescript
import { NextResponse } from 'next/server';
import { config } from '@/lib/config';
import { success } from '@/lib/types';

export async function GET() {
  return NextResponse.json(
    success({
      status: 'healthy',
      demoMode: config.isDemoMode,
      timestamp: new Date().toISOString(),
    })
  );
}
```

### Step 9: Verify Setup

```bash
# Install dependencies
npm install

# Run in demo mode
DEMO_MODE=true npm run dev

# In another terminal, test health endpoint
curl http://localhost:3000/api/health
```

You should see:
```json
{"ok":true,"data":{"status":"healthy","demoMode":true,"timestamp":"..."}}
```

---

## Checklist Before Starting Development

- [ ] Project created with Next.js 14+ App Router
- [ ] .claude folder with settings and commands copied
- [ ] CLAUDE.md customized for this project
- [ ] /lib/config.ts created
- [ ] /lib/types.ts created
- [ ] /lib/services with mock and real implementations
- [ ] .env.example created
- [ ] .env.local created and gitignored
- [ ] Health endpoint working
- [ ] Demo mode verified working

---

## Next Steps

1. Run `/sme-prototype` to start your first feature
2. Use `/compound-engineering:workflows:plan` for any significant work
3. Always verify demo mode works before considering production handoff
