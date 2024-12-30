import { LightningElement } from 'lwc';

export default class ActiveDrivers extends LightningElement {
    // Datos simulados de los pilotos
    drivers = [
        {
            Id: '001',
            Name: 'Max Verstappen',
            Team: 'Red Bull Racing',
            Sponsor: 'Oracle',
            ImageUrl: '/resource/User',
        },
        {
            Id: '002',
            Name: 'Lewis Hamilton',
            Team: 'Mercedes',
            Sponsor: 'Petronas',
            ImageUrl: '/resource/User',
        },
        {
            Id: '003',
            Name: 'Charles Leclerc',
            Team: 'Ferrari',
            Sponsor: 'Shell',
            ImageUrl: '/resource/User',
        },
    ];
}
