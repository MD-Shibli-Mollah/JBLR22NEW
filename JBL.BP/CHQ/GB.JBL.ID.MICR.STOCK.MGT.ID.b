* @ValidationCode : Mjo0OTc2NjQ2NTg6Q3AxMjUyOjE2NjA3MTE2NjAwOTk6bmF6aWI6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfU1A5LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 17 Aug 2022 10:47:40
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : nazib
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_SP9.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
SUBROUTINE GB.JBL.ID.MICR.STOCK.MGT.ID
*
    $INSERT  I_COMMON
    $INSERT  I_EQUATE
    $INSERT I_F.EB.JBL.MICR.STOCK.MGT

    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.ErrorProcessing

    FN.CHQ.TYPE='FBNK.EB.JBL.MICR.STOCK.MGT'
    F.CHQ.TYPE=''

    EB.DataAccess.Opf(FN.CHQ.TYPE, F.CHQ.TYPE)

    Y.TR.TYPE = EB.SystemTables.getComi()
    !Y.TR.TYPE = 'PPP'

    ALPHA.ARRAY = "A" :@FM: "B" :@FM: "C" :@FM: "D" :@FM: "E" :@FM: "F" :@FM: "G" :@FM: "H" :@FM: "I" :@FM: "J" :@FM: "K" :@FM: "L" :@FM: "M" :@FM: "N" :@FM: "O" :@FM: "P" :@FM: "Q" :@FM: "R" :@FM: "S" :@FM: "T" :@FM: "U" :@FM: "V" :@FM: "W" :@FM: "X" :@FM: "Y" :@FM: "Z"

    TYPE.ARRAY = "SB" :@FM: "CD" :@VM: "CURR" :@VM: "STD" :@VM: "SOD" :@VM: "CCHY" :@VM: "CCH" :@FM: "DD" :@FM: "PO" :@FM: "SD" :@FM: "TR" :@FM: "PS" :@FM: "FD" :@FM: "MT" :@FM: "FC" :@FM: "FD"

    IF EB.SystemTables.getVFunction() EQ "I" THEN
        FIND LEFT(Y.TR.TYPE,2) IN TYPE.ARRAY SETTING V.FLD, V.VAL ELSE NULL
        IF(TYPE.ARRAY<V.FLD,1> NE '' AND LEN(Y.TR.TYPE) GT 2) THEN
            EB.SystemTables.setComi(EB.SystemTables.getComi())
        END
        ELSE
            FIND EB.SystemTables.getComi() IN TYPE.ARRAY SETTING V.FLD, V.VAL ELSE NULL

            Y.TR.TYPE = TYPE.ARRAY<V.FLD,1>

            IF (Y.TR.TYPE NE '') THEN
                SEL.CMD = "SELECT ":FN.CHQ.TYPE:" WITH TR.TYPE EQ ":Y.TR.TYPE
                EB.DataAccess.Readlist(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)
                IF (NO.OF.REC EQ 0) THEN
                    !EB.SystemTables.setIdNew(Y.TR.TYPE:"A")
                    EB.SystemTables.setComi(Y.TR.TYPE:"A")
                END
                ELSE
                    FOR V.I = NO.OF.REC TO NO.OF.REC
                        IF(LEN(SEL.LIST) EQ 3) THEN
                            EB.DataAccess.FRead(FN.CHQ.TYPE,SEL.LIST,REC.BOOK,F.CHQ.TYPE,ERR.REQ)
                            IF (REC.BOOK<EB.JBL86.BALANCE>) LT 1000 THEN
                                FIND RIGHT(SEL.LIST,1) IN ALPHA.ARRAY SETTING V.FLD, V.VAL ELSE NULL
                                EB.SystemTables.setComi(Y.TR.TYPE : ALPHA.ARRAY<V.FLD + 1,2>)
                            END
                            ELSE
                                EB.SystemTables.setComi(SEL.LIST)
                            END
                        END
                        !ELSE
                        !   ID.NEW = SEL.LIST
                        !END
                    NEXT V.I
                END
            END
            ELSE
                EB.SystemTables.setE("INVALID PARAMETER")
                EB.ErrorProcessing.StoreEndError()
                RETURN
            END
        END
        RETURN
    END
END