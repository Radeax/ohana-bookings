# Dev Notes & Snippets

# Dev Notes & Snippets

Quick reference for code patterns, commands, and solutions you discover during development.

---

## Useful Commands

### Monorepo

```bash
# Install dependencies
pnpm install

# Run dev (both API and frontend)
turbo dev

# Run API only
pnpm --filter api dev

# Run frontend only
pnpm --filter frontend dev
```

### Database (Drizzle)

```bash
# Generate migration
pnpm --filter api drizzle-kit generate

# Run migrations
pnpm --filter api drizzle-kit migrate

# Open Drizzle Studio (DB GUI)
pnpm --filter api drizzle-kit studio
```

### Docker

```bash
# Start services
docker-compose up -d

# Stop services
docker-compose down

# View logs
docker-compose logs -f

# Reset database (careful!)
docker-compose down -v
docker-compose up -d
```

### Git

```bash
# Create feature branch
git checkout -b feature/branch-name

# Commit with conventional commits
git commit -m "feat: add user authentication"
git commit -m "fix: resolve login token issue"
git commit -m "docs: update API documentation"
```

---

## Code Patterns

### NestJS Controller Pattern

```tsx
@Controller('entities')
@UseGuards(JwtAuthGuard)
export class EntitiesController {
  constructor(private readonly entitiesService: EntitiesService) {}

  @Get()
  findAll(@Query() filters: FilterDto) {
    return this.entitiesService.findAll(filters);
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.entitiesService.findOne(id);
  }

  @Post()
  @Roles('admin', 'coordinator')
  create(@Body() createDto: CreateEntityDto, @CurrentUser() user: User) {
    return this.entitiesService.create(createDto, [user.id](http://user.id));
  }

  @Patch(':id')
  update(@Param('id') id: string, @Body() updateDto: UpdateEntityDto) {
    return this.entitiesService.update(id, updateDto);
  }

  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.entitiesService.remove(id);
  }
}
```

### Vue Component Pattern (Pinia Colada)

```
<script setup lang="ts">
import { useQuery, useMutation, useQueryClient } from '@pinia/colada';
import { useToast } from 'primevue/usetoast';

const toast = useToast();
const queryClient = useQueryClient();

// Fetch data
const { data, isLoading, error } = useQuery({
  key: ['entities'],
  query: () => api.getEntities(),
});

// Create mutation
const { mutate: createEntity, isPending } = useMutation({
  mutation: (data) => api.createEntity(data),
  onSuccess: () => {
    toast.add({ severity: 'success', summary: 'Created!', life: 3000 });
    queryClient.invalidateQueries({ key: ['entities'] });
  },
  onError: (error) => {
    toast.add({ severity: 'error', summary: 'Error', detail: error.message });
  },
});
</script>
```

---

## Troubleshooting

### Common Issues

**Problem:** Database connection fails

**Solution:** Check Docker is running, verify DATABASE_URL in .env

**Problem:** CORS error from frontend

**Solution:** Add frontend URL to CORS whitelist in main.ts

**Problem:** JWT token expired

**Solution:** Implement refresh token flow, check token expiry times

**Problem:** Migration fails

**Solution:** Check schema syntax, ensure database is up, rollback and retry

---

## Learning Resources

**NestJS:**

- Official docs: [https://docs.nestjs.com](https://docs.nestjs.com)
- Authentication: [https://docs.nestjs.com/security/authentication](https://docs.nestjs.com/security/authentication)

**Drizzle ORM:**

- Official docs: [https://orm.drizzle.team](https://orm.drizzle.team)
- Schema reference: [https://orm.drizzle.team/docs/sql-schema-declaration](https://orm.drizzle.team/docs/sql-schema-declaration)

**Vue 3:**

- Official docs: [https://vuejs.org](https://vuejs.org)
- Composition API: [https://vuejs.org/guide/extras/composition-api-faq.html](https://vuejs.org/guide/extras/composition-api-faq.html)

**PrimeVue:**

- Components: [https://primevue.org/components](https://primevue.org/components)
- Theming: [https://primevue.org/theming](https://primevue.org/theming)

---

## Notes

*Add your own notes, discoveries, and solutions here as you develop*