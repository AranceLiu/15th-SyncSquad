import { Controller } from "@hotwired/stimulus";
import { patch } from "@rails/request.js";

// Connects to data-controller="map"
export default class extends Controller {
  static targets = ["field", "map"];
  connect() {
    const location = this.mapTarget.dataset.mapLocation;
    const lat = Number(this.mapTarget.dataset.mapLatitude);
    const lng = Number(this.mapTarget.dataset.mapLongitude);
    if (location) {
      this.mapTarget.style.height = "400px";
      this.locationMap(lat, lng);
    } else {
      this.mapTarget.style.height = "0";
    }
    this.autocomplete = new google.maps.places.Autocomplete(this.fieldTarget);
    this.autocomplete.addListener(
      "place_changed",
      this.placeChanged.bind(this)
    );
  }
  locationMap(lat, lng) {
    const map = new google.maps.Map(this.mapTarget, {
      center: {
        lat: lat,
        lng: lng,
      },
      zoom: 15,
    });
    new google.maps.Marker({
      position: {
        lat: lat,
        lng: lng,
      },
      map: map,
    });
  }
  placeChanged() {
    this.mapTarget.style.height = "400px";
    const place = this.autocomplete.getPlace();
    const changeLat = place.geometry.location.lat();
    const changeLng = place.geometry.location.lng();
    const map = new google.maps.Map(this.mapTarget, {
      center: {
        lat: changeLat,
        lng: changeLng,
      },
      zoom: 15,
    });
    new google.maps.Marker({
      position: {
        lat: changeLat,
        lng: changeLng,
      },
      map: map,
    });
    this.updateLocation(changeLat, changeLng);
  }
  async updateLocation(latitude, longitude) {
    const id = this.mapTarget.dataset.mapId;
    const url = `/tasks/${id}/update_location`;
    const data = { latitude: latitude, longitude: longitude };
    const result = await patch(url, {
      body: JSON.stringify(data),
    });
  }
}
