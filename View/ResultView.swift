//
//  ResultView.swift
//  Kiara
//
//  Created by Fabian Sand on 20.12.23.
//
import SwiftUI
import Charts

struct AngleStruct : Identifiable{
    let id : Int
    let angle : Float
}
struct ResultView: View {
    
    @Binding var isPresented: Bool
    let stored3DPredictions : [[[Float]]]
    let storedAnglePredictions : [[Int]]
    
    var body: some View {
        
        NavigationView {
            ZStack(alignment: .bottom) {
                List {
                    //makeChart(data:stored3DPredictions, label:"knee angle", index:0).padding(20)
                    
                    ForEach((0...(Predictions.angles_to_calculate.count-1)), id: \.self) {
                        makeChartIndex(index: ($0) )
                    }
                    /*
                    for i in 0...Predictions.angles_to_calculate.count{
                        let angles = storedAnglePredicitions[i]
                        let label = Predictions.joint_names[Predictions.angles_to_calculate[i].0] + "angle"
                        makeChart(data: angles, label: label)
                    }*/
                }.listRowSpacing(20)
                .padding(.top, 20)
                
                HomeTabBarView(isPresented:$isPresented)
            }.navigationTitle("Results").background(.blue).navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func makeChartIndex(index:Int) -> AnyView{
        print(" Found Predictions")
        print(storedAnglePredictions.count)
        //let angles = storedAnglePredictions[index]
        let label = Predictions.joint_names_36m[Predictions.angles_to_calculate[index].0] + "angle"
        return makeChart(data: storedAnglePredictions, index: index, label: label)
    }
    
    private func makeChart(data:[[Int]], index:Int, label:String) -> AnyView{
        var chartDataInput = [AngleStruct]()
        
        if(data.count == 0){
            return AnyView(Text("No Angles recorded"))
        }
            
        for i in 0...Int(data.count - 1){
            chartDataInput.append(AngleStruct(id: i, angle: Float(data[i][index])))
        }
        
        
        return AnyView(HStack{
            Text(label)
            
            if #available(iOS 16.0, *) {
                Chart(chartDataInput) {
                    LineMark(
                        x: .value("id", $0.id),
                        y: .value("value", $0.angle)
                    )
                }.frame(width: 200,height: 200)
            }else {
                Text("IOS version 16 Needed for result charts")
            }
        })
    }
    
    private func makeChart(data:[[[Float]]],label:String,index:Int) -> AnyView{
        var chartDataInput = [AngleStruct]()
        
        
        for i in 0...Int(data.count - 1){
            chartDataInput.append(AngleStruct(id: i, angle: data[i][index][0]) )
        }
        
        return AnyView(HStack{
            Text(label)
            
            if #available(iOS 16.0, *) {
                Chart(chartDataInput) {
                    LineMark(
                        x: .value("id", $0.id),
                        y: .value("value", $0.angle)
                    )
                }.frame(width: 200,height: 200)
            }else {
                Text("IOS version 16 Needed for result charts")
            }
        })
    }
}
