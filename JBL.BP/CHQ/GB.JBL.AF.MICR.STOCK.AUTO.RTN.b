* @ValidationCode : MjoxMTc5MDcwMzAxOkNwMTI1MjoxNjYwNjQyMzk0ODk5Om5hemliOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX1NQOS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 16 Aug 2022 15:33:14
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
SUBROUTINE GB.JBL.AF.MICR.STOCK.AUTO.RTN
*
*Retrofitted By:
*    Date         : 16/08/2022
*    Developed By : Md. Nazibul Islam (Peal)
*    Designation  : Software Engineer
*    Email        : nazibul.ntl@nazihargroup.com
*    Attached To  :
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.EB.JBL.MICR.STOCK.MGT
    
    $USING EB.DataAccess
    $USING EB.SystemTables

    FN.TR.TYPE='FBNK.EB.JBL.MICR.STOCK.MGT'
    F.TR.TYPE=''

    EB.DataAccess.Opf(FN.TR.TYPE, F.TR.TYPE)

    Y.STOCK.ID = EB.SystemTables.getIdNew()
    Y.TR.TYPE = LEFT(Y.STOCK.ID, 2)

    IF EB.SystemTables.getVFunction() EQ "I" THEN

        EB.DataAccess.FRead(FN.TR.TYPE,Y.STOCK.ID,REC.STOCK,F.TR.TYPE,ERR.STK)

        IF REC.STOCK EQ '' THEN
            ALPHA.ARRAY = "A" :VM: 1 :FM: "B" :VM: 2 :FM: "C" :VM: 3 :FM: "D" :VM: 4 :FM: "E" :VM: 5 :FM: "F" :VM: 6 :FM: "G" :VM: 7 :FM: "H" :VM: 8 :FM: "I" :VM: 9 :FM: "J" :VM: 10 :FM: "K" :VM: 11 :FM: "L" :VM: 12 :FM: "M" :VM: 13 :FM: "N" :VM: 14 :FM: "O" :VM: 15 :FM: "P" :VM: 16 :FM: "Q" :VM: 17 :FM: "R" :VM: 18 :FM: "S" :VM: 19 :FM: "T" :VM: 20 :FM: "U" :VM: 21 :FM: "V" :VM: 22 :FM: "W" :VM: 23 :FM: "X" :VM: 24 :FM: "Y" :VM: 25 :FM: "Z" :VM: 26

            FIND RIGHT(Y.STOCK.ID, 1) IN ALPHA.ARRAY SETTING V.FLD, V.VAL ELSE NULL

            ALPHA.VAL = ALPHA.ARRAY<V.FLD,2>

            TYPE.ARRAY = "SB" :VM: 10 :FM: "CD" :VM: 11 :FM: "DD" :VM: 15 :FM: "PO" :VM: 19 :FM: "SD" :VM: 21 :FM: "TR" :VM: 25 :FM: "PS" :VM: 27 :FM: "FD" :VM: 29 :FM: "MT" :VM: 31 :FM: "FC" :VM: 61 :VM: 62 :VM: 63 :VM: 64 :VM: 65 :FM: "FD" :VM: 71 :VM: 72 :VM: 73 :VM: 74 :VM: 75

            FIND Y.TR.TYPE IN TYPE.ARRAY SETTING V.FLD, V.VAL ELSE NULL

            Y.TR.CODE = TYPE.ARRAY<V.FLD,2>

            EB.SystemTables.setRNew(EB.JBL86.TR.PREFIX, Y.STOCK.ID)
            EB.SystemTables.setRNew(EB.JBL86.TR.TYPE, Y.TR.TYPE)
            EB.SystemTables.setRNew(EB.JBL86.TR.CODE, Y.TR.CODE)
            EB.SystemTables.setRNew(EB.JBL86.PREFIX.NO, Y.TR.CODE : ALPHA.VAL)
            EB.SystemTables.setRNew(EB.JBL86.STARTING.NO, '0000001')
            EB.SystemTables.setRNew(EB.JBL86.ENDING.NO, '9999900')
            EB.SystemTables.setRNew(EB.JBL86.LAST.USED.NO, '0000000')
            EB.SystemTables.setRNew(EB.JBL86.BALANCE, (EB.SystemTables.getRNew(EB.JBL86.ENDING.NO) - EB.SystemTables.getRNew(EB.JBL86.LAST.USED.NO)))
            EB.SystemTables.setRNew(EB.JBL86.STATUS, "ISSUED")

        END

    END

RETURN
END