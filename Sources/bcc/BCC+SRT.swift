//
//  BCC+SRT.swift
//  bcc
//
//  Created by Apollo Zhu on 10/19/18.
//

import srt

extension BCC {
    public init(srt: SRT, verbose: Bool) throws {
        self.init(body: srt.body.map {
            BCC.Subtitle(
                from: $0.startTime,
                to: $0.endTime,
                content: $0.content.joined(separator: "\n")
            )
        })
    }
}
