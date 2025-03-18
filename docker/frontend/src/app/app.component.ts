import { Component } from '@angular/core';
import { HomeComponent } from './components/home/home.component';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [HomeComponent], // Ensure only valid imports
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent { }