import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { TareasModule } from './tareas/tareas.module';

@Module({
  imports: [TareasModule],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
