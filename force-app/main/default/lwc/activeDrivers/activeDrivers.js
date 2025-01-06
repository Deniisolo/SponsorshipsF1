import { LightningElement, wire } from 'lwc';
import getActiveDrivers from '@salesforce/apex/DriverController.getActiveDrivers';

export default class ActiveDrivers extends LightningElement {
    drivers;

    @wire(getActiveDrivers)
    wiredDrivers({ error, data }) {
        if (data) {
            this.drivers = data;
        } else if (error) {
            console.error('Error fetching drivers:', error);
        }
    }
}