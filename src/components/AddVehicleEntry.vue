<template>
    <div class="modal-container">
       <div class="modal">
       <button @click="closeModalPopUp()" class="modal__close">&times;</button>
        <div class="modal__title">
            Add new entry
        </div>
        <div class="modal-content">
            <div class="vehicle__details">
            <div class="title toll-title-name required">
                Select toll name
            </div>
            <div class="details">
                 <select v-model="entry.tollName" name="tollName" id="vType"  class="vehicleType input">
                        <option v-if="tollNames.length > 0" value=""> Select Toll Name</option>
                        <option :key="toll" v-for="toll in tollNames" :value="toll">{{toll}}</option>
                        <option v-if="tollNames.length === 0" value="">No Tolls Found</option>
    
                    </select>
                

            </div>
            </div>
            <div class="vehicle__details">
            <div class="title select__vehicle required">
                Select vehicle type
            </div>
            <div class="details">
                 <select v-model="entry.vehicleType" name="vehicleType" id="vType"  :change= "calculateTariff()"  class="vehicleType input">
                        <option value="">Select Vehicle Type</option>
                        <option value="Car/Jeep/Van">Car/Jeep/Van</option>
                        <option value="LCU">LCU</option>
                        <option value="Truck/Bus">Truck/Bus</option>
                        <option value="Heavy vehicle">Heavy vehicle</option>
                    </select>
                

            </div>
            </div>
            <div class="vehicle__details">
            <div class="title vehicleno required">
                Vehicle Number
            </div>
            <div class="details">
                 <input v-model="entry.vehicleNo" type="text" name="vNumber" id="" class="vNum input" placeholder="Enter the vehicle Number">
                

            </div>
            </div>
            <div class="vehicle__details">
            <div class="title tamount required">
                Tariff
            </div>
            <div class="details">
             <input v-model="entry.tariff" type="text" name="tamount" id="" class="tNum input" placeholder="Tariff amount" :disabled = true>
            </div>
            </div> 
        </div>
        <div class="submit-entry">  
            <button @click="addVehicle()" class="addEntry" :disabled="isValid()">Add Entry</button>
        </div>
    </div>
   </div>
</template>

<script>
export default {
    name: "AddModal",
    data: () => {
        return {
            entry : {
                tollName: '',
                vehicleType: '',
                vehicleNo: '',
                tariff: '',
                date: ''
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
            vehicleList: [],
            tollNames: [],
            
        }
    },
    methods: {
        closeModalPopUp() {
            this.$emit('closeVModal');
        },
        addVehicle() {
            this.entry.date = new Date().toLocaleString();
             this.vehicleList.push({tName: this.entry.tollName, vType: this.entry.vehicleType, vNo: this.entry.vehicleNo,
             tariff: this.entry.tariff, date: this.entry.date})
             sessionStorage.setItem('ViewList', JSON.stringify(this.vehicleList));
             this.$emit('view-vehicle-list', {tName: this.entry.tollName, vType: this.entry.vehicleType, vNo: this.entry.vehicleNo,
             tariff: this.entry.tariff, date: this.entry.date});
             alert('Vehicle Added Successfully');
            
        },
        isValid() {
            if(this.entry.tollName && this.entry.vehicleType && this.entry.vehicleNo && this.entry.tariff) {
                return false;
            } else {
                return true;
            }
        },
        calculateTariff() {
            const tollDetails = JSON.parse(sessionStorage.getItem('tollDetails'));
            const viewList = JSON.parse(sessionStorage.getItem('ViewList'));
            const tollInfo = tollDetails?.find(name => name.tollName === this.entry.tollName);
            if(this.entry.tollName) {
            const vhData = viewList?.find(val => {
                if(val.vNo === this.entry.vehicleNo && val.tName === this.entry.tollName) {
                       return val;
                }
                });
            const entryDate = this.parseDate(vhData?.date);
             const currDate = new Date();
             const ONE_HOUR = 60 * 60 * 1000
            if(currDate - entryDate < ONE_HOUR) {
              let fare;
               for(const detail in tollInfo?.fareDetails) {
                if(this.entry.vehicleType === tollInfo?.fareDetails[detail].type) {
                    fare = tollInfo?.fareDetails[detail].single + '/' + tollInfo?.fareDetails[detail].return;
                }
            }
            this.entry.tariff = fare;
            } else {
                let fare;
               for(const detail in tollInfo?.fareDetails) {
                if(this.entry.vehicleType === tollInfo?.fareDetails[detail].type) {
                    fare = tollInfo?.fareDetails[detail].single;
                }
            }
            this.entry.tariff = fare;
            }
           
           
            
            }
            
            
        },
        parseDate(detail) {
            if(detail) {
            const [date,time] = detail.split(',');
            const fullDate = date?.split('/');
            const fullTime = time?.split(':');
            const parsedDate = new Date(fullDate[2],fullDate[1],fullDate[0],fullTime[0],fullTime[1],fullTime[2]);
            return parsedDate
            }
           
        }
    },
    created() {
        const geList = JSON.parse(sessionStorage.getItem('ViewList'));
        if(geList) {
            this.vehicleList.push(...geList);
            sessionStorage.setItem('ViewList', JSON.stringify(this.vehicleList));
        } 
    },
    mounted() {
        const updatedTollName = JSON.parse(sessionStorage.getItem('tollNames'));
        this.tollNames = updatedTollName ? updatedTollName : [];
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
    width: 55%;
    padding: 24px;
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
    width: 195px;
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