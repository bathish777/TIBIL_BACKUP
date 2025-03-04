/* eslint-disable @typescript-eslint/no-explicit-any */
import { Injectable } from '@angular/core';
import { DashboardPage } from '../dashboard/dashboard.page';

@Injectable({
  providedIn: 'root'
})
export class CommonServiceService {

  constructor() { }
 public selectedTab: string = 'dashboard'


  
}
