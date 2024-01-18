*-----------------------------------------------------------------------------
* <Rating>1388</Rating>
*-----------------------------------------------------------------------------
!SUBROUTINE E.BUILD.STAT.LINE.DETS
    PROGRAM E.ABL.STAT.LINE.BAL
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.RE.STAT.LINE.CONT
    $INSERT I_F.CONSOLIDATE.ASST.LIAB
    $INSERT I_F.CONSOLIDATE.PRFT.LOSS
    $INSERT I_F.CURRENCY

    DEBUG
    Y.COMPANY = 'BD0010902'
    Y.GL.CODE = 'JBGL.0165'
    O.DATA = Y.GL.CODE:".":Y.COMPANY

    F.RE.STAT.LINE.CONT = ''
    CALL OPF("F.RE.STAT.LINE.CONT", F.RE.STAT.LINE.CONT)
*
    F.CONSOLIDATE.ASST.LIAB = ''
    CALL OPF("F.CONSOLIDATE.ASST.LIAB", F.CONSOLIDATE.ASST.LIAB)
*
    F.CONSOLIDATE.PRFT.LOSS = ''
    CALL OPF("F.CONSOLIDATE.PRFT.LOSS", F.CONSOLIDATE.PRFT.LOSS)
*
    MAX.SMC = '' ; KEYPOS = ''
*
    LINE.DETAILS = ''
    READ CONT.REC FROM F.RE.STAT.LINE.CONT, O.DATA THEN
*
        AL.PL = 'AL'
        KEYS = CONT.REC<RE.SLC.ASST.CONSOL.KEY>
        CCY.TYPES = CONT.REC<RE.SLC.ASSET.TYPE>
        GOSUB BUILD.DATA
*
! AL.PL = 'PL'
        KEYS = CONT.REC<RE.SLC.PRFT.CONSOL.KEY>
        CCY.TYPES = CONT.REC<RE.SLC.PROFIT.CCY>
        SIGN.LIST = CONT.REC<RE.SLC.PROFIT.SIGN>
        GOSUB BUILD.DATA
    END
*
    FOR YI = 1 TO 5
        R.RECORD<24+YI> = LINE.DETAILS<YI>
    NEXT YI
*
    VM.COUNT = DCOUNT(LINE.DETAILS<1>,VM)
*
    RETURN
*
*-------------------------------------------------------------------------
BUILD.DATA:
*==========
** Process each key and type ccy calculate the balance and return if not
** zero in LINE.DETAILS structure
**   LINE.DETAILS<1,x> = key
**   LINE.DETAILS<2,x,y> = type/ccy
**   LINE.DETAILS<3,x,y> = Balance in ccy
**   LINE.DETAILS<4,x,y> = Local balance
**   LINE.DETAILS<5,x,y> = ccy
*
    DEBUG

    KEY.DET.CNT = ''
    LOOP
        REMOVE CON.KEY FROM KEYS SETTING YD
    WHILE CON.KEY:YD
        KEY.DET.CNT += 1
        SMC = ''
        IF AL.PL = 'AL' THEN
            READ AL.REC FROM F.CONSOLIDATE.ASST.LIAB, CON.KEY THEN
                TYPES = CCY.TYPES<1,KEY.DET.CNT>
                LOOP
                    REMOVE CHK.TYPE FROM TYPES SETTING YD2
                WHILE CHK.TYPE:YD2
                    LOCATE CHK.TYPE IN AL.REC<RE.ASL.TYPE,1> SETTING TYPE.POS THEN
                        CCY = AL.REC<RE.ASL.CURRENCY>
                        BAL = AL.REC<RE.ASL.BALANCE,TYPE.POS> + AL.REC<RE.ASL.DEBIT.MOVEMENT,TYPE.POS> + AL.REC<RE.ASL.CREDIT.MOVEMENT,TYPE.POS>
                        IF CCY = LCCY THEN
                            LOCAL.BAL = BAL
                        END ELSE
                            LOCAL.BAL = AL.REC<RE.ASL.LOCAL.BALANCE,TYPE.POS> + AL.REC<RE.ASL.LOCAL.DEBIT.MVE,TYPE.POS> + AL.REC<RE.ASL.LOCAL.CREDT.MVE,TYPE.POS>
                        END
                        IF LOCAL.BAL THEN
                            KEYPOS += 1 ;* Add in next position
                            LINE.DETAILS<1,KEYPOS> = CON.KEY
                            LINE.DETAILS<2,KEYPOS> = CHK.TYPE
                            LINE.DETAILS<5,KEYPOS> = CCY
                            LINE.DETAILS<4,KEYPOS> = LOCAL.BAL
                            LINE.DETAILS<3,KEYPOS> = BAL
                        END
                    END
                REPEAT
            END
        END ELSE
            READ PL.REC FROM F.CONSOLIDATE.PRFT.LOSS, CON.KEY THEN
                TYPES = CCY.TYPES<1,KEY.DET.CNT>
*100000467se
                PROFIT.SIGN = SIGN.LIST<1,KEY.DET.CNT>
                LOOP
                    REMOVE CCY FROM TYPES SETTING YD2
                WHILE CCY:YD2
                    LOCATE CCY IN PL.REC<RE.PTL.CURRENCY,1> SETTING CCYP THEN
                        BEGIN CASE
                        CASE CONT.REC<RE.SLC.PROFIT.PERIOD> = 'CM'
                            LOCAL.BAL = PL.REC<RE.PTL.BALANCE,CCYP> + PL.REC<RE.PTL.DEBIT.MOVEMENT,CCYP> + PL.REC<RE.PTL.CREDIT.MOVEMENT,CCYP>
                            IF CCY NE LCCY THEN
                                BAL = PL.REC<RE.PTL.CCY.BALANCE,CCYP> + PL.REC<RE.PTL.CCY.DEBIT.MVE,CCYP> + PL.REC<RE.PTL.CCY.CREDT.MVE,CCYP>
                            END ELSE
                                BAL = LOCAL.BAL
                            END
                        CASE CONT.REC<RE.SLC.PROFIT.PERIOD> = 'YTD'
                            LOCAL.BAL = PL.REC<RE.PTL.BALANCE.YTD,CCYP>
                            IF CCY NE LCCY THEN
                                BAL = PL.REC<RE.PTL.CCY.BALANCE.YTD,CCYP>
                            END ELSE
                                BAL = LOCAL.BAL
                            END
                        CASE 1
                            LOCAL.BAL = PL.REC<RE.PTL.BALANCE,CCYP> + PL.REC<RE.PTL.DEBIT.MOVEMENT,CCYP> + PL.REC<RE.PTL.CREDIT.MOVEMENT,CCYP> + PL.REC<RE.PTL.BALANCE.YTD,CCYP>
                            IF CCY NE LCCY THEN
                                BAL = PL.REC<RE.PTL.CCY.BALANCE,CCYP> + PL.REC<RE.PTL.CCY.DEBIT.MVE,CCYP> + PL.REC<RE.PTL.CCY.CREDT.MVE,CCYP> + PL.REC<RE.PTL.CCY.BALANCE.YTD,CCYP>
                            END ELSE
                                BAL = LOCAL.BAL
                            END
                        END CASE
                        IF LOCAL.BAL THEN
*BG_100000467
                            IF LOCAL.BAL GE 0 AND BAL GE 0 AND PROFIT.SIGN EQ 'DEBIT' THEN CONTINUE
                            IF LOCAL.BAL LT 0 AND BAL LT 0 AND PROFIT.SIGN EQ 'CREDIT' THEN CONTINUE
*BG_100000467
                            KEYPOS += 1
                            LINE.DETAILS<1,KEYPOS> = CON.KEY
                            LINE.DETAILS<2,KEYPOS> = CCY
                            LINE.DETAILS<5,KEYPOS> = CCY
                            LINE.DETAILS<4,KEYPOS> = LOCAL.BAL
                            LINE.DETAILS<3,KEYPOS> = BAL
                        END
                    END
                REPEAT
            END
        END
    REPEAT
*
    RETURN
END
