<template>
   <div class="modal-container">
       <div class="modal">
       <button @click="closeModalPopUp()" class="modal__close">&times;</button>
        <div class="modal__title">
            Add new toll
        </div>
        <div class="modal__header">
            <div class="header">
                <div class="toll_head required">Toll Name</div>
                <input v-model="toll.tollDetails" type="text" placeholder="Enter toll name" class="tollName">
            </div>
        </div>
        <div class="modal-content">
            <div class="content__title required">
                Vehicle fare details
            </div>
            <div class="content__details">
                <div class="vehicle car">
                 <div class="detail__input">
                    <select v-model="toll.fareDetails.vehicle_1.type" name="vehicleType" id="vType" class="vehicleType">
                        <option value="">Select Vehicle Type</option>
                        <option value="Car/Jeep/Van">Car/Jeep/Van</option>
                        <option value="LCU">LCU</option>
                        <option value="Truck/Bus">Truck/Bus</option>
                        <option value="Heavy vehicle">Heavy vehicle</option>
                    </select>
                </div>
                <div class="detail__single">
                    <input v-model="toll.fareDetails.vehicle_1.single" type="number" name="single__journey" class="single" placeholder="Single Journey">
                </div>
                <div class="detail__return">
                    <input v-model="toll.fareDetails.vehicle_1.return" type="number" name="return__journey" class="return" placeholder="Return Journey">
                </div>
                </div>
                <div class="vehicle lcu">
                 <div class="detail__input">
                    <select v-model="toll.fareDetails.vehicle_2.type" name="vehicleType" id="vType" class="vehicleType">
                        <option value="">Select Vehicle Type</option>
                        <option value="Car/Jeep/Van">Car/Jeep/Van</option>
                        <option value="LCU">LCU</option>
                        <option value="Truck/Bus">Truck/Bus</option>
                        <option value="Heavy vehicle">Heavy vehicle</option>
                    </select>
                </div>
                <div class="detail__single">
                    <input v-model="toll.fareDetails.vehicle_2.single" type="number" name="single__journey" class="single" placeholder="Single Journey">
                </div>
                <div class="detail__return">
                    <input v-model="toll.fareDetails.vehicle_2.return" type="number" name="return__journey" class="return" placeholder="Return Journey">
                </div>
                </div>
                <div class="vehicle bus">
                 <div class="detail__input">
                    <select v-model="toll.fareDetails.vehicle_3.type" name="vehicleType" id="vType" class="vehicleType">
                        <option value="">Select Vehicle Type</option>
                        <option value="Car/Jeep/Van">Car/Jeep/Van</option>
                        <option value="LCU">LCU</option>
                        <option value="Truck/Bus">Truck/Bus</option>
                        <option value="Heavy vehicle">Heavy vehicle</option>
                    </select>
                </div>
                <div class="detail__single">
                    <input v-model="toll.fareDetails.vehicle_3.single" type="number" name="single__journey" class="single" placeholder="Single Journey">
                </div>
                <div class="detail__return">
                    <input v-model="toll.fareDetails.vehicle_3.return" type="number" name="return__journey" class="return" placeholder="Return Journey">
                </div>
                </div>
                <div class="vehicle heavy">
                 <div class="detail__input">
                    <select v-model="toll.fareDetails.vehicle_4.type" name="vehicleType" id="vType" class="vehicleType">
                        <option value="">Select Vehicle Type</option>
                        <option value="Car/Jeep/Van">Car/Jeep/Van</option>
                        <option value="LCU">LCU</option>
                        <option value="Truck/Bus">Truck/Bus</option>
                        <option value="Heavy vehicle">Heavy vehicle</option>
                    </select>
                </div>
                <div class="detail__single">
                    <input v-model="toll.fareDetails.vehicle_4.single" type="number" name="single__journey" class="single" placeholder="Single Journey">
                </div>
                <div class="detail__return">
                    <input v-model="toll.fareDetails.vehicle_4.return" type="number" name="return__journey" class="return" placeholder="Return Journey">
                </div>
                </div>
                

            </div>
        </div>
        <div class="submit-btn">
            <button @click="addNewToll()" class="add-btn">Add Details</button>
        </div>
    </div>
   </div>
</template>


<script>
export default {
    name: "AddTollModal",
    data: () => {
        return {
            entry : {
                tollName: '',
                vehicleType: '',
                vehicleNo: '',
                tariff: ''
            },
            toll: {
                tollDetails: '',
                fareDetails: {
                    vehicle_1: {
                        type: '',
                        single: '',
                        return: ''
                    },
                    vehicle_2: {
                        type: '',
                        single: '',
                        return: ''
                    },
                    vehicle_3: {
                        type: '',
                        single: '',
                        return: ''
                    },
                    vehicle_4: {
                        type: '',
                        single: '',
                        return: ''
                    }
                }
            },
            tollList: [],
            tollNames: [],
        }
    },
    methods: {
        closeModalPopUp() {
            this.$emit('closeTollModal');
        },
        addNewToll() {
            this.tollList.push({tollName: this.toll.tollDetails.trim(), fareDetails: this.toll.fareDetails});
            this.tollNames.push(this.toll.tollDetails);
            sessionStorage.setItem('tollDetails', JSON.stringify(this.tollList));
            sessionStorage.setItem('tollNames', JSON.stringify(this.tollNames));
            this.$emit('updated-toll-names', {tollName: this.toll.tollDetails.trim(), fareDetails: this.toll.fareDetails});
            alert('Toll Details Added Successfully');


        },
        isValid() {
            if(this.entry.tollName && this.entry.vehicleType && this.entry.vehicleNo && this.entry.tariff) {
                return false;
            } else {
                return true;
            }
        }
    },
    created() {
         const prevList = JSON.parse(sessionStorage.getItem('tollDetails'));
            const prevName = JSON.parse(sessionStorage.getItem('tollNames'));
            if(prevList && prevName) {
                 this.tollList.push(...prevList);
                  this.tollNames.push(...prevName);
            sessionStorage.setItem('tollDetails', JSON.stringify(this.tollList));
            sessionStorage.setItem('tollNames', JSON.stringify(this.tollNames));
            } 
           
    },

}
</script>

<style scoped>

.modal-container {
    position: fixed;
    top: 50%;
    left: 50%;
    width: 100%;
    z-index: 999;
    transform: translate(-50%, -50%);
    height: 100vh;
    -webkit-backdrop-filter: contrast(0.5);
    backdrop-filter: contrast(0.5);
    background-color: #4444446b;
}
.modal {
    background: #fff;
    padding: 24px;
    width: 65%;
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
}
.modal__title {
    text-align: center;
}
.content__title {
    margin-left: 12px;
    margin-bottom: 8px;
}
.vehicle {
    display: flex;
    justify-content: space-around;
    align-items: center;
    margin-bottom: 28px;

}

.vehicleType,.single,.return {
    width: 220px;
    padding: 12px 12px;
    border: 1px solid #44444436;
}
.toll_head {
    margin-bottom: 12px;
}
.header {
    margin-left: 12px;
}
.tollName {
    width: 100%;
    margin-bottom: 16px;
    padding: 12px 12px;
    border: 1px solid #44444436;
}
.submit-btn {
    margin: 32px 0 12px 0;
}
.add-btn {
    width: 100%;
}
.modal__close {
    cursor: pointer;
    font-size: 28px;
    background: transparent;
    position: absolute;
    top: -5px;
    left: 93%;
    color: #28282880;
}
.close {
    opacity: 0;
    visibility: hidden;
}
.open {
    opacity: 1;
    visibility: visible;
}
.vehicle__details {
    text-align: center;
}
.title {
    width: 160px; 
}
.toll-title-name, .vehicleno {
  margin-left: 40px;
  margin-bottom: 8px;

}

.select__vehicle {
    margin-left: 48px;
    margin-bottom: 8px;
}
.input {
    width: 85%;
    padding: 12px 12px;
    border: 1px solid #44444436;

}
.vehicle__details {
    margin-bottom: 14px;
}
.tamount {
      margin-bottom: 8px;
}

.submit-entry {
    text-align: center;
}
.addEntry {
    width: 90%;
    margin: 32px 0 12px 9px;
}
</style>