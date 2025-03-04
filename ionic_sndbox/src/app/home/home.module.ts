import { IonCheckbox } from '@ionic/angular/standalone';
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
// import { IonCheckbox, IonicModule } from '@ionic/angular'; 
import { FormsModule } from '@angular/forms'; 
import { IonicModule } from '@ionic/angular';
@NgModule({
  imports: [
    CommonModule,
    IonicModule, 
    FormsModule,
    IonCheckbox
  ],
  declarations: [],
})
export class HomePageModule { }
