import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { IonContent, IonHeader, IonTitle, IonToolbar, IonSpinner } from '@ionic/angular/standalone';
import { Router } from '@angular/router';
import { ApiService } from '../services/api.service'; // Import ApiService to fetch accounts

@Component({
  selector: 'app-loader-page',
  templateUrl: './loader-page.page.html',
  styleUrls: ['./loader-page.page.scss'],
  standalone: true,
  imports: [IonHeader, CommonModule, FormsModule],
})
export class LoaderPagePage implements OnInit {
  mobile: string = '';
  errorMessage: string = '';

  constructor(private router: Router, private apiService: ApiService) { }

  ngOnInit() {
  }


  showLoader: boolean = true;

  // Function to show the loader
  show() {
    this.showLoader = true;
  }

  // Function to hide the loader
  hide() {
    this.showLoader = false;
  }

}
