require 'rails_helper'

RSpec.describe ValidadSchedules, type: :service do
    let(:data_developer) {
        {
            "locations": [
                {
                "id": 1,
                "schedules": [
                    {
                        "weekdays": "Seg. à Sex.",
                        "hour": "06h às 10h"
                    },
                    {
                        "weekdays": "Sáb.",
                        "hour": "Fechada"
                    },
                    {
                        "weekdays": "Dom.",
                        "hour": "Fechada"
                    }
                ]
                },
                {
                "id": 2,
                "schedules": [
                    {
                        "weekdays": "Seg. à Sex.",
                        "hour": "06h às 23h"
                    },
                    {
                        "weekdays": "Sáb.",
                        "hour": "06h às 14h"
                    },
                    {
                        "weekdays": "Dom.",
                        "hour": "06h às 14h"
                    }
                ]
                },
                {
                "id": 3,
                "schedules": [
                    {
                        "weekdays": "Seg. à Sex.",
                        "hour": "06h às 23h"
                    },
                    {
                        "weekdays": "Sáb.",
                        "hour": "06h às 10h"
                    },
                    {
                        "weekdays": "Dom.",
                        "hour": "Fechada"
                    }
                ]
                }
            ]
        }.to_json
    }
    let(:units) { false }

    subject { described_class.new(data_developer, period, units) }

    describe '#call' do
        context 'when filter location period morning' do
            let(:period) { 'morning' }
            let(:expect_developer) {
                [
                    {
                        "id"=>1, 
                        "schedules"=>[
                            {"weekdays"=>"Seg. à Sex.", "hour"=>"06h às 10h"}
                        ]
                    }, 
                    {
                        "id"=>2, 
                        "schedules"=>[
                            {"weekdays"=>"Seg. à Sex.", "hour"=>"06h às 23h"}, 
                            {"weekdays"=>"Sáb.", "hour"=>"06h às 14h"}, 
                            {"weekdays"=>"Dom.", "hour"=>"06h às 14h"}
                        ]
                    }, 
                    {
                        "id"=>3, 
                        "schedules"=>[
                            {"weekdays"=>"Seg. à Sex.", "hour"=>"06h às 23h"}, 
                            {"weekdays"=>"Sáb.", "hour"=>"06h às 10h"}
                        ]
                    }
                ]
            }

            it 'return hours morning' do
                expect(subject.call).to eq(expect_developer)
            end
        end

        context 'when filter location period afternoon' do
            let(:period) { 'afternoon' }
            let(:expect_developer) {
                [
                    {
                        "id"=>2, 
                        "schedules"=>[
                            {"weekdays"=>"Seg. à Sex.", "hour"=>"06h às 23h"}, 
                            {"weekdays"=>"Sáb.", "hour"=>"06h às 14h"}, 
                            {"weekdays"=>"Dom.", "hour"=>"06h às 14h"}
                        ]
                    }, 
                    {
                        "id"=>3, 
                        "schedules"=>[
                            {"weekdays"=>"Seg. à Sex.", "hour"=>"06h às 23h"}
                        ]
                    }
                ]
            }

            it 'return hours afternoon' do
                expect(subject.call).to eq(expect_developer)
            end
        end

        context 'when filter location period night' do
            let(:period) { 'night' }
            let(:expect_developer) {
                [
                    {
                        "id"=>2, 
                        "schedules"=>[
                            {"weekdays"=>"Seg. à Sex.", "hour"=>"06h às 23h"}
                        ]
                    }, 
                    {
                        "id"=>3, 
                        "schedules"=>[
                            {"weekdays"=>"Seg. à Sex.", "hour"=>"06h às 23h"}
                        ]
                    }
                ]
            }

            it 'return hours night' do
                expect(subject.call).to eq(expect_developer)
            end
        end

        context 'when filter location period night and units true' do
            let(:period) { 'night' }
            let(:units) { true }
            let(:expect_developer) {
                [
                    {
                        "id"=>1, 
                        "schedules"=>[
                            {"hour"=> "Fechada", "weekdays"=>"Sáb."},
                            {"hour"=> "Fechada", "weekdays"=>"Dom."}
                        ]
                    }, 
                    {
                        "id"=>2, 
                        "schedules"=>[
                            {"hour"=>"06h às 23h", "weekdays"=>"Seg. à Sex."}
                        ]
                    }, 
                    {
                        "id"=>3, 
                        "schedules"=>[
                            {"hour"=>"06h às 23h", "weekdays"=>"Seg. à Sex."},
                            {"hour"=> "Fechada", "weekdays"=>"Dom."}
                        ]
                    }
                ]
            }

            it 'return hours night and hours Fechada' do
                expect(subject.call).to eq(expect_developer)
            end
        end
    end
end
